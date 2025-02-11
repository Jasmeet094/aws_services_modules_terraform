locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier
  tags       = merge(module.common_tags.output, var.tags)
}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags?ref=v0.1.2"
  environment = terraform.workspace
  name        = local.identifier
}

resource "aws_eks_fargate_profile" "profile" {
  pod_execution_role_arn = var.pod_execution_role_arn
  fargate_profile_name   = local.identifier
  cluster_name           = var.cluster_name
  subnet_ids             = var.subnet_ids

  dynamic "selector" {
    for_each = { for selector in var.profile_selectors : selector.namespace => selector }

    content {
      namespace = selector.value.namespace
      labels    = selector.value.labels
    }
  }

  tags = local.tags
}
