data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier
  tags       = merge(module.common_tags.output, var.tags)
  kms_policy = <<EOF
{
 "Version": "2012-10-17",
    "Id": "key-default-1",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        }    
    ]
}
EOF
  log_delivery_configuration = [
    {
      destination      = module.cloudwatch_log_group_slow_log.output.log_group.name
      destination_type = "cloudwatch-logs"
      log_format       = "text"
      log_type         = "slow-log"
    },
    {
      destination      = module.cloudwatch_log_group_engine_log.output.log_group.name
      destination_type = "cloudwatch-logs"
      log_format       = "json"
      log_type         = "engine-log"
    }
  ]
  elasticache_subnet_group_name = var.elasticache_subnet_group_name != "" ? var.elasticache_subnet_group_name : join("", aws_elasticache_subnet_group.default.*.name)
}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags?ref=v0.1.2"
  environment = terraform.workspace
  name        = local.identifier
}

module "kms" {
  source = "github.com/nclouds/terraform-aws-kms?ref=v0.1.5"
  count  = var.at_rest_encryption_enabled ? 1 : 0

  append_workspace = false
  description      = "EKS Encryption key for ${local.identifier}"
  identifier       = local.identifier
  policy           = local.kms_policy
  tags             = local.tags
}

module "cloudwatch_log_group_slow_log" {
  source            = "github.com/nclouds/terraform-aws-cloudwatch?ref=v0.1.17"
  retention_in_days = var.log_delivery_cloudwatch_retention_in_days
  identifier        = "/aws/elasticache/${local.identifier}-slowlog"
}

module "cloudwatch_log_group_engine_log" {
  source            = "github.com/nclouds/terraform-aws-cloudwatch?ref=v0.1.17"
  retention_in_days = var.log_delivery_cloudwatch_retention_in_days
  identifier        = "/aws/elasticache/${local.identifier}-enginelog"
}

# Create a Security Group
module "elasticache_security_group" {
  source     = "github.com/nclouds/terraform-aws-security-group?ref=v0.2.9"
  identifier = "${local.identifier}-elasticache"
  vpc_id     = var.vpc_id
  tags       = local.tags
}

resource "aws_elasticache_subnet_group" "default" {
  count      = var.elasticache_subnet_group_name == "" && length(var.subnet_ids) > 0 ? 1 : 0
  subnet_ids = var.subnet_ids
  name       = local.identifier
}

resource "aws_elasticache_parameter_group" "default" {
  name        = local.identifier
  description = "Elasticache parameter group for ${local.identifier}"
  family      = var.family

  dynamic "parameter" {
    for_each = var.cluster_mode_enabled ? concat([{ name = "cluster-enabled", value = "yes" }], var.parameter) : var.parameter
    content {
      name  = parameter.value.name
      value = tostring(parameter.value.value)
    }
  }

  tags = local.tags

  # Ignore changes to the description since it will try to recreate the resource
  lifecycle {
    ignore_changes = [
      description,
    ]
  }
}

resource "aws_elasticache_replication_group" "default" {

  description                 = coalesce(var.description, "Elasticache Replaication Group for ${local.identifier}")
  replication_group_id        = var.replication_group_id == null ? local.identifier : var.replication_group_id
  apply_immediately           = var.apply_immediately
  at_rest_encryption_enabled  = var.at_rest_encryption_enabled
  auth_token                  = var.transit_encryption_enabled ? var.auth_token : null
  transit_encryption_enabled  = var.transit_encryption_enabled || var.auth_token != null
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  automatic_failover_enabled  = var.cluster_mode_enabled ? true : var.automatic_failover_enabled
  preferred_cache_cluster_azs = length(var.preferred_cache_cluster_azs) == 0 ? null : [for n in range(0, var.cluster_size) : element(var.preferred_cache_cluster_azs, n)]
  num_node_groups             = var.cluster_mode_enabled ? var.cluster_mode_num_node_groups : null
  replicas_per_node_group     = var.cluster_mode_enabled ? var.cluster_mode_replicas_per_node_group : null
  num_cache_clusters          = var.cluster_mode_enabled ? null : var.cluster_size
  engine_version              = var.engine_version
  final_snapshot_identifier   = var.final_snapshot_identifier
  kms_key_id                  = var.at_rest_encryption_enabled ? module.kms[0].output.key_id : null

  dynamic "log_delivery_configuration" {
    for_each = local.log_delivery_configuration

    content {
      destination      = lookup(log_delivery_configuration.value, "destination", null)
      destination_type = lookup(log_delivery_configuration.value, "destination_type", null)
      log_format       = lookup(log_delivery_configuration.value, "log_format", null)
      log_type         = lookup(log_delivery_configuration.value, "log_type", null)
    }
  }
  maintenance_window       = var.maintenance_window
  multi_az_enabled         = var.multi_az_enabled
  node_type                = var.instance_type
  notification_topic_arn   = var.notification_topic_arn
  parameter_group_name     = aws_elasticache_parameter_group.default.name
  port                     = var.port
  security_group_ids       = concat([module.elasticache_security_group.output.security_group.id], var.additonal_security_group_ids)
  snapshot_arns            = var.snapshot_arns
  snapshot_name            = var.snapshot_name
  snapshot_retention_limit = var.snapshot_retention_limit
  snapshot_window          = var.snapshot_window
  subnet_group_name        = local.elasticache_subnet_group_name
  tags                     = local.tags
}
