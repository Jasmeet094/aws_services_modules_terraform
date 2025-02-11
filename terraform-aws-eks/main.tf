data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags?ref=v0.1.2"
  environment = terraform.workspace
  name        = local.identifier
}

locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier
  tags       = merge(module.common_tags.output, var.tags)

  kms_policy = <<EOF
{
 "Version": "2012-10-17",
    "Id": "key-default-1",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "logs.${data.aws_region.current.name}.amazonaws.com"
            },
            "Action": [
                "kms:Encrypt*",
                "kms:Decrypt*",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:Describe*"
            ],
            "Resource": "*",
            "Condition": {
                "ArnEquals": {
                    "kms:EncryptionContext:aws:logs:arn": "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/eks/${local.identifier}/cluster"
                }
            }
        }    
    ]
}
EOF
}

resource "aws_iam_role" "role" {
  force_detach_policies = true
  description           = "Created by terraform for EKS Control Plane"
  name                  = local.identifier

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "extra_policies" {
  count = length(var.policy_arns)

  policy_arn = var.policy_arns[count.index]
  role       = aws_iam_role.role.name
}

resource "aws_iam_role_policy_attachment" "cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.role.name
}

resource "aws_iam_role_policy_attachment" "service" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.role.name
}

resource "aws_iam_role_policy_attachment" "sg-for-pods" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.role.name
}

resource "aws_eks_cluster" "control_plane" {
  enabled_cluster_log_types = var.enabled_cluster_log_types
  role_arn                  = aws_iam_role.role.arn
  version                   = var.eks_version
  name                      = local.identifier

  vpc_config {
    endpoint_private_access = var.eks_endpoint_private_access
    endpoint_public_access  = var.eks_endpoint_public_access #tfsec:ignore:AWS069
    public_access_cidrs     = var.public_access_cidrs        #tfsec:ignore:AWS068
    security_group_ids      = var.security_group_ids
    subnet_ids              = var.subnet_ids
  }

  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = module.kms.output.key_arn
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster,
    aws_iam_role_policy_attachment.service,
    module.log_group
  ]

  tags = local.tags
}

# KMS
module "kms" {
  source = "github.com/nclouds/terraform-aws-kms.git?ref=v0.1.5"

  append_workspace = false
  description      = "EKS Encryption key for ${local.identifier}"
  identifier       = local.identifier
  policy           = local.kms_policy
  tags             = local.tags
}

resource "aws_iam_openid_connect_provider" "this" {
  count = var.create_oidc_provider ? 1 : 0

  thumbprint_list = var.thumbprint_list
  client_id_list  = var.client_id_list
  tags            = local.tags
  url             = aws_eks_cluster.control_plane.identity.0.oidc.0.issuer
}

module "log_group" {

  source = "github.com/nclouds/terraform-aws-cloudwatch.git?ref=v0.1.17"

  retention_in_days  = var.log_group_retention_in_days
  append_workspace   = false
  identifier         = "/aws/eks/${local.identifier}/cluster"
  kms_key_id         = module.kms.output.key_arn
  tags               = local.tags
  use_name_prefix    = false
  use_custom_kms_key = true
}
