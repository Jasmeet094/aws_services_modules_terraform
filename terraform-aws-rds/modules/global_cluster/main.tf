locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier
}

resource "aws_rds_global_cluster" "this" {
  source_db_cluster_identifier = var.source_db_cluster_identifier
  global_cluster_identifier    = local.identifier
  deletion_protection          = var.deletion_protection
  storage_encrypted            = var.storage_encrypted
  engine_version               = var.engine_version
  database_name                = var.database_name
  force_destroy                = var.force_destroy
  engine                       = var.engine
}