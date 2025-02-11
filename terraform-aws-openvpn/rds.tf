resource "random_password" "password" {
  special = false
  length  = 16

  keepers = {
    static = "1"
  }
}

#tfsec:ignore:aws-rds-enable-performance-insights
resource "aws_rds_cluster_instance" "db_instance" {
  count                = var.use_rds ? 1 : 0
  identifier           = "rds-vpn-${lower(var.environment)}"
  cluster_identifier   = aws_rds_cluster.db_cluster[0].id
  instance_class       = var.db_instance_type
  publicly_accessible  = false
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group[0].id
  tags = merge(local.tags, {
    "Name" = "RDS-VPN-${var.environment}"
  })
}

#tfsec:ignore:AWS051
resource "aws_rds_cluster" "db_cluster" {
  count                     = var.use_rds ? 1 : 0
  cluster_identifier        = "rds-vpn-${lower(var.environment)}"
  snapshot_identifier       = var.snapshot_identifier
  master_username           = var.rds_master_name
  master_password           = random_password.password.result
  final_snapshot_identifier = "RDS-VPN-${var.environment}-final-${md5(timestamp())}"
  backup_retention_period   = var.rds_backup_retention_period
  port                      = 3306
  db_subnet_group_name      = aws_db_subnet_group.db_subnet_group[0].id
  vpc_security_group_ids    = [module.openvpn-rds-sg.output.security_group.id]
  storage_encrypted         = var.rds_storage_encrypted
  apply_immediately         = var.apply_immediately
  tags = merge(local.tags, {
    "Name" = "RDS-VPN-${var.environment}"
  })

  lifecycle {
    ignore_changes = [snapshot_identifier, final_snapshot_identifier]
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  count       = var.use_rds ? 1 : 0
  name        = "openvpn-db-subnet-group-${lower(var.environment)}"
  description = "Allowed subnets for OpenVPN RDS cluster instances"
  subnet_ids  = length(var.private_subnet_ids) == 0 ? tolist(data.aws_subnets.private.*.ids) : var.private_subnet_ids
  tags = merge(local.tags, {
    "Name" = "DB-DUBNET-GROUP-VPN-${var.environment}"
  })
}
