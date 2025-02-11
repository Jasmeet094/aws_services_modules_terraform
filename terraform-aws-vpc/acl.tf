resource "aws_network_acl" "public_layer" {
  count = length(var.vpc_settings["public_subnets"])

  subnet_ids = [local.public_subnets[count.index].id]
  vpc_id     = aws_vpc.vpc.id
  tags       = merge(local.tags, { Name = "${local.identifier}-public-nacl" })
}

resource "aws_network_acl" "data_layer" {
  count = length(var.vpc_settings["data_subnets"])

  subnet_ids = [local.data_subnets[count.index].id]
  vpc_id     = aws_vpc.vpc.id
  tags       = merge(local.tags, { Name = "${local.identifier}-data-nacl" })
}

resource "aws_network_acl" "application_layer" {
  count = length(var.vpc_settings["application_subnets"])

  subnet_ids = [local.application_subnets[count.index].id]
  vpc_id     = aws_vpc.vpc.id
  tags       = merge(local.tags, { Name = "${local.identifier}-application-nacl" })
}

### This allow all ephemeral ports on private subnets
#tfsec:ignore:aws-ec2-no-public-ingress-acl
resource "aws_network_acl_rule" "ingress-all-ephemmeral-tcp-data" {
  count = length(var.vpc_settings["data_subnets"])

  network_acl_id = aws_network_acl.data_layer[count.index].id
  rule_action    = "allow"
  rule_number    = 100
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  protocol       = "tcp"
  to_port        = 65535
  egress         = false
}

#tfsec:ignore:aws-ec2-no-public-ingress-acl
resource "aws_network_acl_rule" "ingress-all-ephemmeral-tcp-app" {
  count = length(var.vpc_settings["application_subnets"])

  network_acl_id = aws_network_acl.application_layer[count.index].id
  rule_action    = "allow"
  rule_number    = 100
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  protocol       = "tcp"
  to_port        = 65535
  egress         = false
}

#tfsec:ignore:aws-ec2-no-public-ingress-acl
resource "aws_network_acl_rule" "ingress-all-ephemmeral-udp-data" {
  count = length(var.vpc_settings["data_subnets"])

  network_acl_id = aws_network_acl.data_layer[count.index].id
  rule_action    = "allow"
  rule_number    = 101
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  protocol       = "udp"
  to_port        = 65535
  egress         = false
}

#tfsec:ignore:aws-ec2-no-public-ingress-acl
resource "aws_network_acl_rule" "ingress-all-ephemmeral-udp-app" {
  count = length(var.vpc_settings["application_subnets"])

  network_acl_id = aws_network_acl.application_layer[count.index].id
  rule_action    = "allow"
  rule_number    = 101
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  protocol       = "udp"
  to_port        = 65535
  egress         = false
}

### This allow all internal traffic
resource "aws_network_acl_rule" "ingress-all-internal-data" {
  count = length(var.vpc_settings["data_subnets"])

  network_acl_id = aws_network_acl.data_layer[count.index].id
  rule_action    = "allow"
  rule_number    = 1000
  cidr_block     = var.vpc_settings["cidr"] #tfsec:ignore:AWS050
  from_port      = 0
  protocol       = -1
  to_port        = 0
  egress         = false
}

### This allow all internal traffic from allowed cidrs in data subnets
resource "aws_network_acl_rule" "ingress-custom-internal-data" {
  for_each = local.custom_data_acl

  network_acl_id = each.value.acl
  rule_action    = "allow"
  rule_number    = 200 + index(keys(local.custom_data_acl), each.key) * 10
  cidr_block     = each.value.cidr
  from_port      = 0
  protocol       = -1
  to_port        = 0
  egress         = false
}

resource "aws_network_acl_rule" "ingress-custom-internal-data-priority" {
  for_each = local.custom_data_acl_priority

  network_acl_id = each.value.acl
  rule_action    = "allow"
  rule_number    = each.value.rule_id
  cidr_block     = each.value.cidr
  from_port      = 0
  protocol       = -1
  to_port        = 0
  egress         = false
}

### This allow all internal traffic
resource "aws_network_acl_rule" "ingress-all-internal-app" {
  count = length(var.vpc_settings["application_subnets"])

  network_acl_id = aws_network_acl.application_layer[count.index].id
  rule_action    = "allow"
  rule_number    = 1000
  cidr_block     = var.vpc_settings["cidr"] #tfsec:ignore:AWS050
  from_port      = 0
  protocol       = -1
  to_port        = 0
  egress         = false
}

### This allow all internal traffic from allowed cidrs in application subnets
resource "aws_network_acl_rule" "ingress-custom-internal-application" {
  for_each = local.custom_application_acl

  network_acl_id = each.value.acl
  rule_action    = "allow"
  rule_number    = 200 + index(keys(local.custom_application_acl), each.key) * 10
  cidr_block     = each.value.cidr
  from_port      = 0
  protocol       = -1
  to_port        = 0
  egress         = false
}

resource "aws_network_acl_rule" "ingress-custom-internal-application-priority" {
  for_each = local.custom_application_acl_priority

  network_acl_id = each.value.acl
  rule_action    = "allow"
  rule_number    = each.value.rule_id
  cidr_block     = each.value.cidr
  from_port      = 0
  protocol       = -1
  to_port        = 0
  egress         = false
}

### This allow all egress traffic
resource "aws_network_acl_rule" "egress-all-app" {
  count = length(var.vpc_settings["application_subnets"])

  network_acl_id = aws_network_acl.application_layer[count.index].id
  rule_action    = "allow"
  rule_number    = 1000
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  protocol       = -1
  to_port        = 0
  egress         = true
}

### This allow all egress traffic
resource "aws_network_acl_rule" "egress-all-data" {
  count = length(var.vpc_settings["data_subnets"])

  network_acl_id = aws_network_acl.data_layer[count.index].id
  rule_action    = "allow"
  rule_number    = 1000
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  protocol       = -1
  to_port        = 0
  egress         = true
}


### This allow all ephemeral ports ingress traffic to public subnets
resource "aws_network_acl_rule" "ingress-all-ephemmeral-tcp-public" {
  count = length(var.vpc_settings["public_subnets"])

  network_acl_id = aws_network_acl.public_layer[count.index].id
  rule_action    = "allow"
  rule_number    = 100
  cidr_block     = "0.0.0.0/0" #tfsec:ignore:aws-vpc-no-public-ingress-acl
  from_port      = 1024
  protocol       = -1
  to_port        = 65535
  egress         = false
}

### This allow all egress traffic from public subnets
resource "aws_network_acl_rule" "egress-all-public" {
  count = length(var.vpc_settings["public_subnets"])

  network_acl_id = aws_network_acl.public_layer[count.index].id
  rule_action    = "allow"
  rule_number    = 1000
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  protocol       = -1
  to_port        = 0
  egress         = true
}
