locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier
  tags       = merge(module.common_tags.output, var.tags)
}

module "common_tags" {
  source      = "git@github.com:nclouds/terraform-aws-common-tags.git?ref=v0.1.2"
  environment = terraform.workspace
  name        = local.identifier
}

resource "aws_elasticache_subnet_group" "default" {
  subnet_ids = var.subnet_ids
  name       = local.identifier
}

#tfsec:ignore:AWS088
resource "aws_elasticache_cluster" "redis" {
  # tflint-ignore: aws_elasticache_cluster_default_parameter_group
  parameter_group_name = var.parameter_group_name
  maintenance_window   = var.maintenance_window
  security_group_ids   = var.sg_redis
  subnet_group_name    = aws_elasticache_subnet_group.default.name
  num_cache_nodes      = var.num_cache_nodes
  engine_version       = var.elasticache_engine_version
  cluster_id           = local.identifier
  node_type            = var.elasticache_instance_type
  engine               = var.elasticache_engine
  port                 = var.port
  tags                 = local.tags
}
