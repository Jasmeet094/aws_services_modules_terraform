locals {
  identifier      = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier
  master_password = var.password == null ? random_password.password.result : var.password #tfsec:ignore:GEN002
  vpc_id          = var.vpc_id
  database_ports = {
    "aurora"            = "3306"
    "aurora-mysql"      = "3306"
    "aurora-postgresql" = "3306"
    "mariadb"           = "3306"
    "mysql"             = "3306"
    "oracle-ee"         = "1521"
    "oracle-ee-cdb"     = "1521"
    "oracle-se2"        = "1521"
    "oracle-se2-cdb"    = "1521"
    "postgres"          = "5432"
    "sqlserver-ee"      = "1433"
    "sqlserver-se"      = "1433"
    "sqlserver-ex"      = "1433"
    "sqlserver-web"     = "1433"
  }
  rds_database_port = var.rds_database_port == 0 ? lookup(local.database_ports, var.engine, "3306") : var.rds_database_port
  tags              = merge(module.common_tags.output, var.tags)
}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags?ref=v0.1.2"
  environment = terraform.workspace
  name        = local.identifier
}

resource "random_password" "password" {
  special = false
  length  = 16

  keepers = {
    static = "1"
  }
}

module "kms" {
  source = "github.com/nclouds/terraform-aws-kms.git?ref=v0.1.5"

  append_workspace = false
  deletion_window  = 10
  description      = "KMS key to store database user and password on secrets manager"
  identifier       = local.identifier
  tags             = local.tags
}

resource "aws_secretsmanager_secret" "master_password" {
  description = "RDS Credentials - Managed by terraform"
  name_prefix = "${local.identifier}-"
  kms_key_id  = module.kms.output.key_id
  tags        = local.tags
}

resource "aws_secretsmanager_secret_version" "example" {
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  secret_string = jsonencode(
    {
      username : var.rds_master_username
      password : local.master_password
    }
  )
  secret_id = aws_secretsmanager_secret.master_password.id
}

resource "aws_db_subnet_group" "main" {
  description = "RDS Subnet Group - ${terraform.workspace}"
  subnet_ids  = var.subnets
  name        = local.identifier

  tags = local.tags
}

resource "aws_db_parameter_group" "main" {
  family = var.rds_parameter_group_family
  name   = local.identifier

  dynamic "parameter" {
    for_each = { for parameter in var.rds_parameters : parameter.name => parameter }

    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = local.tags
}

module "security_group" {
  source = "github.com/nclouds/terraform-aws-security-group.git?ref=v0.2.9"

  vpc_id      = local.vpc_id
  description = "security group for rds instance ${local.identifier}"
  identifier  = "${local.identifier}-sg-rds"
  tags        = local.tags
  ingress_rule_list = [for cidr_block in var.cidr_blocks_ingress : {
    cidr_blocks = tolist([cidr_block]),
    description = "Allow inbound traffic from ${cidr_block}",
    from_port   = local.rds_database_port,
    protocol    = "tcp",
    to_port     = local.rds_database_port
  }]
  ingress_from_security_group_list = [for sg in var.security_groups_ingress : {
    source_security_group_id = sg,
    description              = "Allow inbound traffic from existing ${sg}",
    from_port                = local.rds_database_port,
    protocol                 = "tcp",
    to_port                  = local.rds_database_port
  }]
}

#tfsec:ignore:aws-rds-enable-performance-insights
#tfsec:ignore:AVD-AWS-0177
#tfsec:ignore:AVD-AWS-0176
resource "aws_db_instance" "main" {
  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  final_snapshot_identifier   = local.identifier
  backup_retention_period     = var.backup_retention_period
  vpc_security_group_ids      = concat([module.security_group.output.security_group.id], var.security_groups)
  parameter_group_name        = aws_db_parameter_group.main.id
  db_subnet_group_name        = aws_db_subnet_group.main.id
  publicly_accessible         = var.publicly_accessible
  skip_final_snapshot         = var.skip_final_snapshot
  snapshot_identifier         = var.snapshot_identifier == "" ? null : var.snapshot_identifier
  storage_encrypted           = var.encryption
  allocated_storage           = var.snapshot_identifier == "" ? var.rds_allocated_storage : null
  apply_immediately           = terraform.workspace == "production" ? false : true
  engine_version              = var.rds_engine_version
  instance_class              = var.rds_instance_class
  license_model               = var.license_model
  storage_type                = var.storage_type
  identifier                  = local.identifier
  username                    = var.snapshot_identifier == "" ? var.rds_master_username : null
  password                    = local.master_password
  multi_az                    = var.multi_az
  engine                      = var.snapshot_identifier == "" ? var.engine : null
  db_name                     = var.snapshot_identifier == "" ? var.rds_database_name : null
  port                        = local.rds_database_port

  timeouts {
    create = "45m"
  }

  tags = local.tags
}
