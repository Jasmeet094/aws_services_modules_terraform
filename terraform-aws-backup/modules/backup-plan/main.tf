locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier
  default_tags = {
    Environment = terraform.workspace
    Name        = local.identifier
  }
  tags = merge(module.common_tags.output, var.tags)
}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags?ref=v0.1.2"
  environment = terraform.workspace
  name        = local.identifier
}

resource "aws_backup_plan" "main" {
  name = local.identifier

  rule {
    target_vault_name = var.target_vault_name
    rule_name         = "${local.identifier}-default-backup-rule"
    schedule          = var.schedule

    lifecycle {
      delete_after = var.delete_after
    }
  }

  tags = local.tags
}