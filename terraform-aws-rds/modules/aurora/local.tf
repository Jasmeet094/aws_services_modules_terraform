locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier
  default_tags = {
    Environment = terraform.workspace
    Name        = local.identifier
  }
  tags = merge(local.default_tags, var.tags)

  port                        = var.port == "" ? (var.engine == "aurora-postgresql" ? 5432 : 3306) : var.port
  db_subnet_group_name        = var.db_subnet_group_name == "" ? join("", aws_db_subnet_group.this.*.name) : var.db_subnet_group_name
  master_password             = var.create_random_password && var.is_primary_cluster ? random_password.master_password[0].result : var.password #tfsec:ignore:GEN002
  backtrack_window            = (var.engine == "aurora-mysql" || var.engine == "aurora") && var.engine_mode != "serverless" ? var.backtrack_window : 0
  rds_enhanced_monitoring_arn = var.create_monitoring_role ? join("", aws_iam_role.rds_enhanced_monitoring.*.arn) : var.monitoring_role_arn
  iam_role_name               = var.iam_role_use_name_prefix ? null : coalesce(var.iam_role_name, "rds-enhanced-monitoring-${local.identifier}")
  iam_role_name_prefix        = var.iam_role_use_name_prefix ? "${var.iam_role_name}-" : null
}