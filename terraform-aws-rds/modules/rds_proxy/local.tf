locals {
  identifier = var.append_workspace ? "${var.db_proxy_identifier}-${terraform.workspace}" : var.db_proxy_identifier
  tags       = merge(module.common_tags.output, var.tags)
}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags?ref=v0.1.2"
  environment = terraform.workspace
  name        = local.identifier
}