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
}

module "flow_logs_role" {
  source = "github.com/nclouds/terraform-aws-iam-role?ref=v1.0.2"

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
    data_subnets        = ["10.10.24.0/22", "10.10.28.0/22"]
    dns_support         = true
    tenancy             = "default"
    cidr                = "10.10.0.0/16"
  }
  identifier = "${var.identifier}_vpc"
  region     = "us-east-1"
}

module "rds_security_group" {
  source     = "github.com/nclouds/terraform-aws-security-group.git?ref=v0.2.9"
  identifier = "${var.identifier}-rds"
  self_rule  = true
  vpc_id     = module.vpc.output.vpc.id
}

module "rds_global_cluster" {
  source         = "../"
  engine_version = "11.15"
  identifier     = var.identifier
  engine         = "aurora-postgresql"
}

#tfsec:ignore:AWS019
resource "aws_kms_key" "kms_key" {
  deletion_window_in_days = 7
  description             = "KMS key for rds cluster"
}

module "rds_cluster" {
  source = "../../aurora"

  global_cluster_identifier = module.rds_global_cluster.output.global_cluster.id
  create_random_password    = true
  vpc_security_group_ids    = [module.rds_security_group.output.security_group.id]
  engine_version            = "11.15"
  instance_type             = "db.r5.large"
  replica_count             = 2
  identifier                = var.identifier
  kms_key_id                = aws_kms_key.kms_key.arn
  subnets                   = module.vpc.output.data_subnets.*.id
  engine                    = "aurora-postgresql"
}
