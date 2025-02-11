locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier
  tags       = merge(module.common_tags.output, var.tags)
}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags?ref=v0.1.2"
  environment = terraform.workspace
  name        = local.identifier
}

resource "aws_backup_vault" "main" {
  kms_key_arn = var.kms_key_arn
  name        = local.identifier
  tags        = local.tags
}

resource "aws_backup_vault_policy" "policy" {
  count = var.create_backup_policy ? 1 : 0

  backup_vault_name = aws_backup_vault.main.name
  policy            = var.backup_vault_policy
}