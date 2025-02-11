locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier
  tags       = merge(module.common_tags.output, var.tags)
}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags.git?ref=v0.1.2"
  environment = terraform.workspace
  name        = local.identifier
}

resource "aws_iam_policy" "policy" {
  description = var.description
  policy      = var.rendered_policy
  name        = local.identifier
  path        = var.path
  tags        = local.tags
}
