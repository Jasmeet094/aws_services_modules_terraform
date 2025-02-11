resource "null_resource" "asg_update" {

  triggers = {
    asg_name = module.node_group.output.autoscaling_group.name
  }

  provisioner "local-exec" {
    when        = destroy
    interpreter = ["/bin/bash", "-c"]
    on_failure  = continue
    command     = "aws autoscaling update-auto-scaling-group --auto-scaling-group-name ${self.triggers.asg_name} --desired-capacity 0 --min-size 0"
  }
}

locals {
  policies = {
    logs = {
      actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      resources = [
        "*",
      ]
    }
  }
}

#tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "document" {
  statement {
    actions   = local.policies["logs"]["actions"]
    resources = local.policies["logs"]["resources"]
  }
}

module "iam_policy" {
  source = "github.com/nclouds/terraform-aws-iam-policy?ref=v0.1.11"

  rendered_policy = data.aws_iam_policy_document.document.json
  description     = "IAM Policy for VPC Flow Logs Cloudwatch"
  identifier      = "cw-flow-logs-access"
  tags            = var.tags
}

module "flow_logs_role" {
  source = "github.com/nclouds/terraform-aws-iam-role?ref=v1.0.2"

  iam_policies_to_attach = [
    module.iam_policy.output.policy.arn
  ]

  trusted_service_arns = ["vpc-flow-logs.amazonaws.com"]
  description          = "Example IAM Role"
  identifier           = "${var.identifier}-flow-logs"
  tags                 = var.tags
}

# Create a VPC
module "vpc" {
  count        = var.create_vpc ? 1 : 0
  source       = "git@github.com:nclouds/terraform-aws-vpc.git?ref=v0.3.0"
  multi_nat_gw = false
  flow_log_settings = {
    max_aggregation_interval = 600
    flow_log_destination_arn = null
    logs_retention_in_days   = 30
    log_destination_type     = "cloud-watch-logs"
    enable_flow_log          = true
    iam_role_arn             = module.flow_logs_role.output.role.arn
    traffic_type             = "ALL"
  }
  vpc_settings = {
    application_subnets = ["10.10.16.0/22", "10.10.20.0/22"]
    public_subnets      = ["10.10.0.0/22", "10.10.4.0/22"]
    dns_hostnames       = true
    data_subnets        = []
    dns_support         = true
    tenancy             = "default"
    cidr                = "10.10.0.0/16"
  }
  identifier = "${var.identifier}_vpc"
  region     = "us-east-1"
  tags       = var.tags
}

# Create an ECS Cluster
module "ecs" {
  source = "../../.."
  capacity_providers = [
    module.capacity_provider.output.capacity_provider.name
  ]
  identifier = var.identifier
  tags       = var.tags
}

# Create Nodes 
module "node_group" {
  source                = "git@github.com:nclouds/terraform-aws-autoscaling.git?ref=v0.1.5"
  iam_instance_profile  = module.container_instance_role.output.instance_profile.arn
  user_data_base64      = base64encode(local.container_instance_userdata)
  security_groups       = [module.ecs_security_group.output.security_group.id]
  volume_size           = 30
  image_id              = data.aws_ssm_parameter.ecs_ami.value
  instance_type         = "t3a.medium"
  identifier            = var.identifier
  key_name              = "nclouds-tf"
  protect_from_scale_in = true
  subnets               = var.create_vpc ? module.vpc[0].output.application_subnets.*.id : ["subnet-00a66542d0b1d3b85", "subnet-08cc2c6fd510fb028"]
  tags                  = var.tags
  depends_on = [
    module.capacity_provider.aws_ecs_capacity_provider
  ]
}

# Create a capacity Provider Configuration
module "capacity_provider" {
  source                 = "../"
  identifier             = var.identifier
  auto_scaling_group_arn = module.node_group.output.autoscaling_group.arn
  tags                   = var.tags
}