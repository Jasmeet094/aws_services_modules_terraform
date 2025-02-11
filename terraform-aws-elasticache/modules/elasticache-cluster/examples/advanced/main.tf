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
  source = "git@github.com:nclouds/terraform-aws-iam-policy.git?ref=v0.1.11"

  rendered_policy = data.aws_iam_policy_document.document.json
  description     = "IAM Policy for VPC Flow Logs Cloudwatch"
  identifier      = "cw-flow-logs-access"
}

module "flow_logs_role" {
  source = "git@github.com:nclouds/terraform-aws-iam-role.git?ref=v1.0.2"

  iam_policies_to_attach = [
    module.iam_policy.output.policy.arn
  ]

  trusted_service_arns = ["vpc-flow-logs.amazonaws.com"]
  description          = "Example IAM Role"
  identifier           = "${var.identifier}-flow-logs"
}

# Create a VPC
module "vpc" {
  source       = "git@github.com:nclouds/terraform-aws-vpc.git?ref=v0.3.1"
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
}

# Create a SG
module "security_group" {
  source     = "git@github.com:nclouds/terraform-aws-security-group.git?ref=v0.2.9"
  identifier = "${var.identifier}-elasticache"
  vpc_id     = module.vpc.output.vpc.id
}

# Create Elasticache for Memcached
module "elasticache" {
  source                     = "../.."
  subnet_ids                 = module.vpc.output.public_subnets.*.id
  identifier                 = var.identifier
  sg_redis                   = [module.security_group.output.security_group.id]
  vpc_id                     = module.vpc.output.vpc.id
  elasticache_engine         = "memcached"
  elasticache_engine_version = "1.6.6"
  parameter_group_name       = "default.memcached1.6"
  elasticache_instance_type  = "cache.t2.small"
  maintenance_window         = "sun:13:00-sun:14:00"
  port                       = 11211
  num_cache_nodes            = 2
}
