# Random string to use as master password
resource "random_password" "master_password" {
  count = var.create_random_password ? 1 : 0

  special = false
  length  = 16
}

#tfsec:ignore:AWS095
resource "aws_secretsmanager_secret" "master_password" {
  count = var.create_random_password ? 1 : 0

  description = "RDS Credentials - Managed by terraform"
  name_prefix = "${local.identifier}-"
  tags        = local.tags
}

resource "aws_secretsmanager_secret_version" "example" {
  count = var.create_random_password ? 1 : 0

  secret_string = jsonencode( #tfsec:ignore:GEN003
    {
      username : var.username
      password : local.master_password
    }
  )
  secret_id = aws_secretsmanager_secret.master_password.0.id
}

resource "random_id" "snapshot_identifier" {
  byte_length = 4

  keepers = {
    id = local.identifier
  }
}

resource "aws_db_subnet_group" "this" {
  description = "For Aurora cluster ${local.identifier}"
  subnet_ids  = var.subnets
  name        = local.identifier
  tags        = local.tags
}

resource "aws_security_group" "main" {
  description = "security group for rds instance ${local.identifier}"
  vpc_id      = data.aws_subnet.subnets_data.vpc_id
  name        = "${local.identifier}-sg-rds"
  tags        = local.tags
}

resource "aws_security_group_rule" "ingress_sg" {
  count = length(var.security_groups_ingress)

  source_security_group_id = var.security_groups_ingress[count.index]
  security_group_id        = join("", aws_security_group.main.*.id)
  description              = "Allow inbound traffic from existing Security Groups"
  from_port                = local.port
  protocol                 = "tcp"
  to_port                  = local.port
  type                     = "ingress"
}

resource "aws_security_group_rule" "ingress_cidr_blocks" {
  count = length(var.cidr_block_ingress) > 0 ? 1 : 0

  security_group_id = join("", aws_security_group.main.*.id)
  description       = "Allow inbound traffic from CIDR blocks"
  cidr_blocks       = var.cidr_block_ingress
  from_port         = local.port
  protocol          = "tcp"
  to_port           = local.port
  type              = "ingress"
}

#tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "egress" {
  security_group_id = join("", aws_security_group.main.*.id)
  description       = "Allow all egress traffic"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  to_port           = 0
  type              = "egress"
}

#tfsec:ignore:aws-rds-enable-performance-insights
resource "aws_rds_cluster" "this" {
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  db_cluster_parameter_group_name     = var.db_cluster_parameter_group_name
  enabled_cloudwatch_logs_exports     = var.enabled_cloudwatch_logs_exports
  replication_source_identifier       = var.replication_source_identifier
  preferred_maintenance_window        = var.engine_mode == "serverless" ? null : var.preferred_maintenance_window
  allow_major_version_upgrade         = var.allow_major_version_upgrade
  final_snapshot_identifier           = "${var.final_snapshot_identifier_prefix}-${local.identifier}-${element(concat(random_id.snapshot_identifier.*.hex, [""]), 0)}"
  global_cluster_identifier           = var.global_cluster_identifier
  backup_retention_period             = var.backup_retention_period
  preferred_backup_window             = var.engine_mode == "serverless" ? null : var.preferred_backup_window
  vpc_security_group_ids              = concat([aws_security_group.main.id], var.vpc_security_group_ids)
  copy_tags_to_snapshot               = var.copy_tags_to_snapshot
  db_subnet_group_name                = aws_db_subnet_group.this.id
  enable_http_endpoint                = var.enable_http_endpoint
  deletion_protection                 = var.deletion_protection
  snapshot_identifier                 = var.snapshot_identifier
  skip_final_snapshot                 = var.skip_final_snapshot
  cluster_identifier                  = local.identifier
  apply_immediately                   = var.apply_immediately
  storage_encrypted                   = var.storage_encrypted
  backtrack_window                    = local.backtrack_window
  master_password                     = local.master_password
  master_username                     = var.username
  engine_version                      = var.engine_mode == "serverless" ? null : var.engine_version
  database_name                       = var.database_name
  source_region                       = var.source_region
  engine_mode                         = var.engine_mode
  kms_key_id                          = var.kms_key_id
  iam_roles                           = var.iam_roles
  engine                              = var.engine
  port                                = local.port


  dynamic "scaling_configuration" {
    for_each = length(keys(var.scaling_configuration)) == 0 ? [] : [var.scaling_configuration]

    content {
      seconds_until_auto_pause = lookup(scaling_configuration.value, "seconds_until_auto_pause", null)
      timeout_action           = lookup(scaling_configuration.value, "timeout_action", null)
      max_capacity             = lookup(scaling_configuration.value, "max_capacity", null)
      min_capacity             = lookup(scaling_configuration.value, "min_capacity", null)
      auto_pause               = lookup(scaling_configuration.value, "auto_pause", null)
    }
  }

  dynamic "s3_import" {
    for_each = var.s3_import != null ? [var.s3_import] : []

    content {
      source_engine_version = s3_import.value.source_engine_version
      ingestion_role        = s3_import.value.ingestion_role
      bucket_prefix         = lookup(s3_import.value, "bucket_prefix", null)
      source_engine         = "mysql" # Only engine supported
      bucket_name           = s3_import.value.bucket_name
    }
  }

  tags = local.tags
}

#tfsec:ignore:aws-rds-enable-performance-insights
resource "aws_rds_cluster_instance" "this" {
  count = var.replica_scale_enabled ? var.replica_scale_min : var.replica_count

  performance_insights_kms_key_id = var.performance_insights_kms_key_id
  performance_insights_enabled    = var.performance_insights_enabled
  preferred_maintenance_window    = var.preferred_maintenance_window
  auto_minor_version_upgrade      = var.auto_minor_version_upgrade
  db_parameter_group_name         = var.db_parameter_group_name
  db_subnet_group_name            = aws_db_subnet_group.this.id
  monitoring_role_arn             = local.rds_enhanced_monitoring_arn
  monitoring_interval             = var.monitoring_interval
  publicly_accessible             = try(lookup(var.instances_parameters[count.index], "publicly_accessible"), var.publicly_accessible)
  ca_cert_identifier              = var.ca_cert_identifier
  cluster_identifier              = element(concat(aws_rds_cluster.this.*.id, [""]), 0)
  apply_immediately               = var.apply_immediately
  engine_version                  = var.engine_version
  instance_class                  = try(lookup(var.instances_parameters[count.index], "instance_type"), count.index > 0 ? coalesce(var.instance_type_replica, var.instance_type) : var.instance_type)
  promotion_tier                  = try(lookup(var.instances_parameters[count.index], "instance_promotion_tier"), count.index + 1)
  identifier                      = try(lookup(var.instances_parameters[count.index], "instance_name"), "${local.identifier}-${count.index + 1}")
  engine                          = var.engine

  lifecycle {
    ignore_changes = [
      engine_version
    ]
  }

  tags = local.tags
}

### Enhanced Monitoring

data "aws_iam_policy_document" "monitoring_rds_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "rds_enhanced_monitoring" {
  count = var.create_monitoring_role && var.monitoring_interval > 0 ? 1 : 0

  force_detach_policies = var.iam_role_force_detach_policies
  max_session_duration  = var.iam_role_max_session_duration
  permissions_boundary  = var.iam_role_permissions_boundary
  managed_policy_arns   = var.iam_role_managed_policy_arns
  assume_role_policy    = data.aws_iam_policy_document.monitoring_rds_assume_role.json
  description           = var.iam_role_description
  name_prefix           = local.iam_role_name_prefix
  name                  = local.iam_role_name
  path                  = var.iam_role_path

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  count = var.create_monitoring_role && var.monitoring_interval > 0 ? 1 : 0

  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
  role       = aws_iam_role.rds_enhanced_monitoring[0].name
}

### Autoscaling

resource "aws_appautoscaling_target" "read_replica_count" {
  count = var.replica_scale_enabled ? 1 : 0

  scalable_dimension = "rds:cluster:ReadReplicaCount"
  service_namespace  = "rds"
  max_capacity       = var.replica_scale_max
  min_capacity       = var.replica_scale_min
  resource_id        = "cluster:${element(concat(aws_rds_cluster.this.*.cluster_identifier, [""]), 0)}"
}

resource "aws_appautoscaling_policy" "autoscaling_read_replica_count" {
  count = var.replica_scale_enabled ? 1 : 0

  scalable_dimension = "rds:cluster:ReadReplicaCount"
  service_namespace  = "rds"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "cluster:${element(concat(aws_rds_cluster.this.*.cluster_identifier, [""]), 0)}"
  name               = "target-metric"

  target_tracking_scaling_policy_configuration {
    scale_in_cooldown  = var.replica_scale_in_cooldown
    scale_out_cooldown = var.replica_scale_out_cooldown
    target_value       = var.predefined_metric_type == "RDSReaderAverageCPUUtilization" ? var.replica_scale_cpu : var.replica_scale_connections

    predefined_metric_specification {
      predefined_metric_type = var.predefined_metric_type
    }
  }

  depends_on = [aws_appautoscaling_target.read_replica_count]
}