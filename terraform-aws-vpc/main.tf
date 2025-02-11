data "aws_availability_zones" "available" {}
locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier
  tags       = merge(module.common_tags.output, var.tags)
  kubernetes_public_tags = tomap({
    "kubernetes.io/cluster/${local.identifier}" = "shared",
    "kubernetes.io/role/elb"                    = 1
  })
  kubernetes_private_tags = tomap({
    "kubernetes.io/cluster/${local.identifier}" = "shared",
    "kubernetes.io/role/internal-elb"           = 1
  })

  ### Created Subnets from for_each loop, so we can reference them easily
  application_subnets = values(aws_subnet.application_subnets)
  route_table_list    = concat([aws_route_table.public.id], aws_route_table.data_subnets.*.id, aws_route_table.application.*.id)
  public_subnets      = values(aws_subnet.public_subnets)
  data_subnets        = values(aws_subnet.data_subnets)

  all_subnets_ids_azs = concat(
    [for subnet in aws_subnet.application_subnets : { availability_zone = subnet.availability_zone, id = subnet.id }],
    [for subnet in aws_subnet.public_subnets : { availability_zone = subnet.availability_zone, id = subnet.id }],
    [for subnet in aws_subnet.data_subnets : { availability_zone = subnet.availability_zone, id = subnet.id }]
  )

  subnets_by_az = {
    for j in local.all_subnets_ids_azs : j.availability_zone => j.id...
  }

  custom_data_acl = {
    for obj in setproduct(aws_network_acl.data_layer.*.id, var.allowed_cidr_blocks_data) :
    "${obj[0]}-${obj[1]}" => { acl = obj[0], cidr = obj[1] }
  }

  custom_data_acl_priority = {
    for obj in setproduct(aws_network_acl.data_layer.*.id, var.allowed_cidr_blocks_data_priority) :
    "${obj[0]}-${obj[1].rule_id}" => { acl = obj[0], cidr = obj[1].cidr, rule_id = obj[1].rule_id }
  }

  custom_application_acl = {
    for obj in setproduct(aws_network_acl.application_layer.*.id, var.allowed_cidr_blocks_application) :
    "${obj[0]}-${obj[1]}" => { acl = obj[0], cidr = obj[1] }
  }

  custom_application_acl_priority = {
    for obj in setproduct(aws_network_acl.application_layer.*.id, var.allowed_cidr_blocks_application_priority) :
    "${obj[0]}-${obj[1].rule_id}" => { acl = obj[0], cidr = obj[1].cidr, rule_id = obj[1].rule_id }
  }

  ## private endpoints condition
  private_endpoints_count = var.create_private_endpoints ? 1 : 0

  ### Create NATs option
  option_nat = var.disable_nat_gw ? var.disable_nat_gw : false

  ### AZ count used for multi nat gw setups
  multi_nat_temp = var.multi_nat_gw ? local.az_count : 1
  multi_nat      = local.option_nat ? 0 : local.multi_nat_temp
  az_count       = length(var.vpc_settings["public_subnets"]) > length(data.aws_availability_zones.available.names) ? length(data.aws_availability_zones.available.names) : length(var.vpc_settings["public_subnets"])
}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags?ref=v0.1.2"
  environment = terraform.workspace
  name        = local.identifier
}

resource "aws_vpc" "vpc" {
  enable_dns_hostnames = var.vpc_settings["dns_hostnames"]
  enable_dns_support   = var.vpc_settings["dns_support"]
  instance_tenancy     = var.vpc_settings["tenancy"]
  cidr_block           = var.vpc_settings["cidr"]
  tags                 = local.tags
}

resource "aws_subnet" "public_subnets" {
  for_each = toset(var.vpc_settings["public_subnets"])

  map_public_ip_on_launch = false
  availability_zone = element(
    data.aws_availability_zones.available.names,
    index(var.vpc_settings["public_subnets"], each.key) % length(data.aws_availability_zones.available.names),
  )
  cidr_block = each.key
  vpc_id     = aws_vpc.vpc.id

  tags = merge(var.kubernetes_tagging ? local.kubernetes_public_tags : {}, local.tags, { Name = "${local.identifier}-public-${index(var.vpc_settings["public_subnets"], each.key)}" }, { Tier = "Public" })
}

resource "aws_subnet" "application_subnets" {
  for_each = toset(var.vpc_settings["application_subnets"])

  map_public_ip_on_launch = false
  availability_zone = element(
    data.aws_availability_zones.available.names,
    index(var.vpc_settings["application_subnets"], each.key) % length(data.aws_availability_zones.available.names),
  )
  cidr_block = each.key
  vpc_id     = aws_vpc.vpc.id

  tags = merge(var.kubernetes_tagging ? local.kubernetes_private_tags : {}, local.tags, { Name = "${local.identifier}-application-${index(var.vpc_settings["application_subnets"], each.key)}" }, { Tier = "Application" })
}

resource "aws_subnet" "data_subnets" {
  for_each = toset(var.vpc_settings["data_subnets"])

  map_public_ip_on_launch = false
  availability_zone = element(
    data.aws_availability_zones.available.names,
    index(var.vpc_settings["data_subnets"], each.key) % length(data.aws_availability_zones.available.names),
  )
  cidr_block = each.key
  vpc_id     = aws_vpc.vpc.id

  tags = merge(var.kubernetes_tagging ? local.kubernetes_private_tags : {}, local.tags, { Name = "${local.identifier}-data-${index(var.vpc_settings["data_subnets"], each.key)}" }, { Tier = "Data" })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = local.tags
}

resource "aws_eip" "nat_gw" {
  count = local.multi_nat

  tags = local.tags
  vpc  = true

  depends_on = [aws_subnet.application_subnets, aws_subnet.data_subnets]
}

resource "aws_nat_gateway" "nat_gw" {
  count = local.multi_nat

  allocation_id = aws_eip.nat_gw[count.index].id
  subnet_id     = local.public_subnets[count.index].id
  tags          = merge(local.tags, { Name = "${local.identifier}-nat-gw-${count.index}" })

  depends_on = [
    aws_subnet.application_subnets,
    aws_subnet.data_subnets,
    aws_subnet.public_subnets
  ]
}

### Route Table definition

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge(local.tags, { Name = "${local.identifier}-public" })
}

resource "aws_route_table" "application" {
  count = length(var.vpc_settings["application_subnets"])

  vpc_id = aws_vpc.vpc.id
  tags   = merge(local.tags, { Name = "${local.identifier}-application-${count.index}" })
}

resource "aws_route_table" "data_subnets" {
  count = length(var.vpc_settings["data_subnets"])

  vpc_id = aws_vpc.vpc.id
  tags   = merge(local.tags, { Name = "${local.identifier}-data-${count.index}" })
}

### Default Route definition per layer

resource "aws_route" "internet_gateway_route" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  route_table_id         = aws_route_table.public.id
  depends_on             = [aws_route_table.public]
}

resource "aws_route" "application_nat_gateway_route" {
  count = local.multi_nat > 0 ? length(var.vpc_settings["application_subnets"]) : 0

  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = local.multi_nat > 0 ? aws_nat_gateway.nat_gw[count.index % local.multi_nat].id : "none"
  route_table_id         = aws_route_table.application[count.index].id
  depends_on             = [aws_route_table.application]
}

resource "aws_route" "data_nat_gateway_route" {
  count = local.multi_nat > 0 ? length(var.vpc_settings["data_subnets"]) : 0

  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = local.multi_nat > 0 ? aws_nat_gateway.nat_gw[count.index % local.multi_nat].id : "none"
  route_table_id         = aws_route_table.data_subnets[count.index].id
  depends_on             = [aws_route_table.data_subnets]
}

### route table association

resource "aws_route_table_association" "application_subnets" {
  count = length(var.vpc_settings["application_subnets"])

  route_table_id = aws_route_table.application[count.index].id
  subnet_id      = local.application_subnets[count.index].id
}

resource "aws_route_table_association" "data_subnets" {
  count = length(var.vpc_settings["data_subnets"])

  route_table_id = aws_route_table.data_subnets[count.index].id
  subnet_id      = local.data_subnets[count.index].id
}

resource "aws_route_table_association" "public_subnet" {
  count = length(var.vpc_settings["public_subnets"])

  route_table_id = aws_route_table.public.id
  subnet_id      = local.public_subnets[count.index].id
}

### VPC Endpoints definition

resource "aws_vpc_endpoint" "s3" {
  count = local.private_endpoints_count

  route_table_ids = local.route_table_list
  service_name    = "com.amazonaws.${var.region}.s3"
  vpc_id          = aws_vpc.vpc.id
  tags            = local.tags

  depends_on = [
    aws_subnet.application_subnets
  ]
}

resource "aws_vpc_endpoint" "ecs" {
  count = local.private_endpoints_count

  private_dns_enabled = true
  security_group_ids  = [module.endpoint_sg[count.index].output.security_group.id]
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.${var.region}.ecs"
  subnet_ids          = [for subnet_ids in local.subnets_by_az : sort(subnet_ids)[0]]
  vpc_id              = aws_vpc.vpc.id
  tags                = local.tags

  depends_on = [aws_subnet.application_subnets]
}

data "aws_vpc_endpoint_service" "ssm" {
  service = "ssm"
}

resource "aws_vpc_endpoint" "ssm" {
  count = local.private_endpoints_count

  private_dns_enabled = true
  security_group_ids  = [module.endpoint_sg[count.index].output.security_group.id]
  vpc_endpoint_type   = "Interface"
  service_name        = data.aws_vpc_endpoint_service.ssm.service_name
  subnet_ids          = [for subnet_ids in local.subnets_by_az : sort(subnet_ids)[0]]
  vpc_id              = aws_vpc.vpc.id
  tags                = local.tags

  depends_on = [aws_subnet.application_subnets]
}

data "aws_vpc_endpoint_service" "ecr_api" {
  service = "ecr.api"
}

resource "aws_vpc_endpoint" "ecr_api" {
  count = local.private_endpoints_count

  private_dns_enabled = true
  security_group_ids  = [module.endpoint_sg[count.index].output.security_group.id]
  vpc_endpoint_type   = "Interface"
  service_name        = data.aws_vpc_endpoint_service.ecr_api.service_name
  subnet_ids          = [for subnet_ids in local.subnets_by_az : sort(subnet_ids)[0]]
  vpc_id              = aws_vpc.vpc.id
  tags                = local.tags

  depends_on = [aws_subnet.application_subnets]
}

data "aws_vpc_endpoint_service" "ecr_dkr" {
  service = "ecr.dkr"
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  count = local.private_endpoints_count

  private_dns_enabled = true
  security_group_ids  = [module.endpoint_sg[count.index].output.security_group.id]
  vpc_endpoint_type   = "Interface"
  service_name        = data.aws_vpc_endpoint_service.ecr_dkr.service_name
  subnet_ids          = [for ids in local.subnets_by_az : sort(ids)[0]]
  vpc_id              = aws_vpc.vpc.id
  tags                = local.tags

  depends_on = [aws_subnet.application_subnets]
}

module "endpoint_sg" {
  source = "github.com/nclouds/terraform-aws-security-group.git?ref=v0.2.9"

  count = local.private_endpoints_count

  append_workspace = false

  vpc_id      = aws_vpc.vpc.id
  description = "endpoint sg security group"
  identifier  = local.identifier
  tags        = local.tags
  ingress_rule_list = [{
    cidr_blocks = [var.vpc_settings["cidr"]],
    description = "open all ports and allowing all protocols",
    from_port   = 0,
    protocol    = "-1",
    to_port     = 0
  }]
  egress_rule_list = [{
    cidr_blocks = [var.vpc_settings["cidr"]],
    description = "open all ports and allowing all protocols",
    from_port   = 0,
    protocol    = "-1",
    to_port     = 0
  }]
}

### VPC flow logs
locals {
  create_cloudwatch_log_group = var.flow_log_settings["enable_flow_log"] && var.flow_log_settings["log_destination_type"] != "s3"
  flow_log_destination_arn    = local.create_cloudwatch_log_group ? module.log_group[0].output.log_group.arn : var.flow_log_settings["flow_log_destination_arn"]
}

resource "aws_flow_log" "logs" {
  count = var.flow_log_settings["enable_flow_log"] ? 1 : 0

  max_aggregation_interval = var.flow_log_settings["max_aggregation_interval"]
  log_destination_type     = var.flow_log_settings["log_destination_type"]
  log_destination          = local.flow_log_destination_arn
  traffic_type             = var.flow_log_settings["traffic_type"]
  iam_role_arn             = var.flow_log_settings["iam_role_arn"]
  vpc_id                   = aws_vpc.vpc.id
  tags                     = local.tags
}

resource "aws_kms_key" "flow_log" {
  count = local.create_cloudwatch_log_group ? 1 : 0

  enable_key_rotation = true
  description         = "Encryption key for ${local.identifier} vpc flow logs"
  policy              = data.aws_iam_policy_document.combined.json
  tags                = local.tags
}

resource "aws_kms_alias" "flow_log" {
  count = local.create_cloudwatch_log_group ? 1 : 0

  target_key_id = aws_kms_key.flow_log[0].arn
  name          = "alias/${local.identifier}"
}

module "log_group" {
  count = local.create_cloudwatch_log_group ? 1 : 0

  source = "github.com/nclouds/terraform-aws-cloudwatch.git?ref=v0.1.17"

  retention_in_days = var.flow_log_settings["logs_retention_in_days"]
  append_workspace  = false
  identifier        = "/vpc/flow-logs/${local.identifier}"
  kms_key_id        = aws_kms_key.flow_log[0].arn
  tags              = var.tags

  use_custom_kms_key = true
}
