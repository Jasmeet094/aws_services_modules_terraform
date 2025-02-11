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

data "aws_iam_policy_document" "document" {
  statement {
    actions   = local.policies["logs"]["actions"]
    resources = local.policies["logs"]["resources"]
  }
}

module "iam_policy" {
  source = "git@github.com:nclouds/terraform-aws-iam-policy.git?ref=v0.1.4"

  rendered_policy = data.aws_iam_policy_document.document.json
  description     = "IAM Policy for VPC Flow Logs Cloudwatch"
  identifier      = "cw-flow-logs-access"
  tags            = var.tags
}

module "flow_logs_role" {
  source = "git@github.com:nclouds/terraform-aws-iam-role.git?ref=v0.2.2"

  iam_policies_to_attach = [
    module.iam_policy.output.policy.arn
  ]

  aws_service_principal = "vpc-flow-logs.amazonaws.com"
  description           = "Example IAM Role"
  identifier            = "${var.identifier}-flow-logs"
  tags                  = var.tags
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

# Create a Security Group
module "eks_security_group" {
  source     = "git@github.com:nclouds/terraform-aws-security-group.git?ref=v0.2.2"
  identifier = "${var.identifier}-eks"
  vpc_id     = var.create_vpc ? module.vpc[0].output.vpc.id : "vpc-000fe2b5ddba6bb64"
  tags       = var.tags
}

# EKS Cluster
module "eks" {
  source                     = "git@github.com:nclouds/terraform-aws-eks.git?ref=v0.4.4"
  identifier                 = var.identifier
  security_group_ids         = [module.eks_security_group.output.security_group.id]
  eks_version                = var.eks_version
  eks_endpoint_public_access = true
  subnet_ids                 = var.create_vpc ? concat(module.vpc[0].output.public_subnets.*.id, module.vpc[0].output.application_subnets.*.id) : ["subnet-08cc2c6fd510fb028", "subnet-00a66542d0b1d3b85", "subnet-00718264f27e680ca", "subnet-06c99ae7139b4c163"]
  tags                       = var.tags
}

# IAM ROLE for Workers
module "worker_role" {
  source = "git@github.com:nclouds/terraform-aws-iam-role.git?ref=v0.2.2"
  iam_policies_to_attach = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
  aws_service_principal = "ec2.amazonaws.com"
  identifier            = "${var.identifier}-worker"
  tags                  = var.tags
}

# EKS Node Group
module "node_group" {
  source        = "git@github.com:nclouds/terraform-aws-eks.git//modules/eks-node-group?ref=v0.4.4"
  node_role_arn = module.worker_role.output.role.arn
  cluster_name  = module.eks.output.eks_cluster.name
  identifier    = var.identifier
  subnet_ids    = var.create_vpc ? module.vpc[0].output.application_subnets.*.id : ["subnet-00718264f27e680ca", "subnet-06c99ae7139b4c163"]
  tags          = var.tags
}

# Istio
module "istio" {
  source = "../"
}