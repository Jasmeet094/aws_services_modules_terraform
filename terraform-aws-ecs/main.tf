locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier
  tags       = merge(module.common_tags.output, var.tags)
}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags?ref=v0.1.2"
  environment = terraform.workspace
  name        = local.identifier
}

resource "aws_ecs_cluster" "cluster" {
  name = local.identifier

  setting {
    value = var.container_insights
    name  = "containerInsights"
  }
  tags = local.tags
}

resource "aws_ecs_cluster_capacity_providers" "capacity_provider" {

  count = length(var.capacity_providers) > 0 ? 1 : 0

  cluster_name       = aws_ecs_cluster.cluster.name
  capacity_providers = var.capacity_providers
}
