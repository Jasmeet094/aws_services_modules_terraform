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

# VPC Flow Logs
module "flow_logs_role" {
  source = "github.com/nclouds/terraform-aws-iam-role?ref=v1.0.2"

  iam_policies_to_attach = [
    module.iam_policy.output.policy.arn
  ]

  trusted_service_arns = ["vpc-flow-logs.amazonaws.com"]
  description          = "Example IAM Role"
  identifier           = "${var.identifier}-flow-logs"
}

# REQUESTER VPC
module "requester_network" {
  source       = "../../../../"
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
  identifier = "${var.identifier}_requester_vpc"
  region     = "us-east-1"

}

# VPC PEERING
module "vpc_peering" {
  source = "../../"
  providers = {
    aws.requester = aws.requester_acct
    aws.accepter  = aws.accepter_acct
  }

  requester              = module.requester_network.output.vpc.id
  accepter               = "vpc-123456789"
  accepter_cidr          = "10.20.0.0/16"
  requester_cidr         = module.requester_network.output.vpc.cidr_block
  requester_route_tables = concat(module.requester_network.output.application_route_table.*.id, [module.requester_network.output.public_route_table.id])
  accepter_route_tables  = ["rt-123456789", "rt-98652471", "rt-987654321"]
  identifier             = var.identifier
  region                 = "us-east-1"
}
