locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier

  tags = merge(module.common_tags.output, var.tags)

  ecr_allowed_access = length(var.ecr_allowed_access) == 0 ? "" : "{ \"AWS\": [ \"${join("\", \"", var.ecr_allowed_access)}\" ]},"
  ecr_policy         = local.ecr_allowed_access == "" ? "" : <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "default policy",
            "Effect": "Allow",
            "Principal": {
              "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:DescribeRepositories",
                "ecr:GetRepositoryPolicy",
                "ecr:ListImages",
                "ecr:DeleteRepository",
                "ecr:BatchDeleteImage",
                "ecr:SetRepositoryPolicy",
                "ecr:DeleteRepositoryPolicy"
            ]
        },
          {
            "Sid": "new policy",
            "Effect": "Allow",
            "Principal": ${local.ecr_allowed_access}
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload"
            ]
        }
      ]
    }
EOF

  default_policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "default policy",
            "Effect": "Allow",
            "Principal": {
              "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:DescribeRepositories",
                "ecr:GetRepositoryPolicy",
                "ecr:ListImages",
                "ecr:DeleteRepository",
                "ecr:BatchDeleteImage",
                "ecr:SetRepositoryPolicy",
                "ecr:DeleteRepositoryPolicy"
            ]
        }
    ]
}
EOF
}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags?ref=v0.1.2"
  environment = terraform.workspace
  name        = local.identifier
}

data "aws_caller_identity" "current" {}

#tfsec:ignore:aws-ecr-enable-image-scans
resource "aws_ecr_repository" "ecr" {
  image_tag_mutability = var.image_tag_mutability
  name                 = local.identifier
  tags                 = local.tags

  encryption_configuration {
    encryption_type = var.encryption_type
    kms_key         = var.kms_arn
  }

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}

resource "aws_ecr_lifecycle_policy" "policy" {
  repository = aws_ecr_repository.ecr.name
  policy     = var.policy
}

resource "aws_ecr_repository_policy" "repo_policy" {
  repository = aws_ecr_repository.ecr.name
  policy     = var.repo_policy != "" ? var.repo_policy : local.ecr_policy != "" ? local.ecr_policy : local.default_policy
}
