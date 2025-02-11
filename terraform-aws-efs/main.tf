locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier
  tags       = merge(module.common_tags.output, var.tags)
}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags?ref=v0.1.2"
  environment = terraform.workspace
  name        = local.identifier
}

resource "aws_efs_file_system" "this" {
  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
  performance_mode                = var.performance_mode
  throughput_mode                 = var.throughput_mode
  creation_token                  = local.identifier
  kms_key_id                      = var.kms_key_id
  encrypted                       = var.encrypted #tfsec:ignore:AWS048
  tags                            = local.tags
}

resource "aws_efs_mount_target" "this" {
  count = length(var.subnet_ids)

  security_groups = var.security_groups
  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = var.subnet_ids[count.index]
}