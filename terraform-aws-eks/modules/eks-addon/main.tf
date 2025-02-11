locals {
  tags = merge(module.common_tags.output, var.tags)
}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags?ref=v0.1.2"
  environment = terraform.workspace
}

resource "aws_eks_addon" "this" {
  service_account_role_arn = var.service_account_role_arn
  resolve_conflicts        = var.resolve_conflicts
  addon_version            = var.addon_version
  cluster_name             = var.cluster_name
  addon_name               = var.addon_name

  tags = local.tags
}