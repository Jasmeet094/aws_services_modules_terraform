locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier
  tags       = merge(module.common_tags.output, var.tags)
}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags?ref=v0.1.2"
  environment = terraform.workspace
  name        = local.identifier
}

resource "aws_kms_key" "key" {
  deletion_window_in_days = var.deletion_window
  enable_key_rotation     = var.enable_key_rotation
  description             = var.description == null ? "KMS key for ${local.identifier}" : var.description
  policy                  = var.policy
  tags                    = local.tags
}

resource "aws_kms_alias" "a" {
  count = var.enable_alias ? 1 : 0

  target_key_id = aws_kms_key.key.key_id
  name          = "alias/${local.identifier}"
}
