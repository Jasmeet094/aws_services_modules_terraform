locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier
  tags       = merge(module.common_tags.output, var.tags)
}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags?ref=v0.1.2"
  environment = terraform.workspace
  name        = local.identifier
}

module "kms" {
  source = "github.com/nclouds/terraform-aws-kms?ref=v0.1.5"

  count = !var.use_custom_kms_key ? 1 : 0

  append_workspace = false
  deletion_window  = 10
  identifier       = local.identifier
  tags             = local.tags
  policy           = data.aws_iam_policy_document.combined.json
}

resource "aws_cloudwatch_log_group" "this" {
  retention_in_days = var.retention_in_days
  name_prefix       = var.use_name_prefix ? "${local.identifier}-" : null
  kms_key_id        = var.use_custom_kms_key ? var.kms_key_id : module.kms[0].output.key_arn
  name              = var.use_name_prefix ? null : local.identifier

  tags = local.tags
}
