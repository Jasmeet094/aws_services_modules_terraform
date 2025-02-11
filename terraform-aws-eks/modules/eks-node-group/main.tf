locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier
  tags       = merge(module.common_tags.output, var.tags)
}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags?ref=v0.1.2"
  environment = terraform.workspace
  name        = local.identifier
}

resource "aws_eks_node_group" "this" {
  node_group_name = local.identifier
  instance_types  = var.instance_types
  node_role_arn   = var.node_role_arn
  capacity_type   = var.capacity_type
  cluster_name    = var.cluster_name
  subnet_ids      = var.subnet_ids
  ami_type        = var.ami_type
  labels          = var.labels

  dynamic "taint" {
    for_each = var.taints
    content {
      effect = taint.value.effect
      value  = taint.value.value
      key    = taint.value.key
    }
  }

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  launch_template {
    id      = aws_launch_template.this.id
    version = aws_launch_template.this.latest_version
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  tags = local.tags
}

resource "aws_launch_template" "this" {
  update_default_version = true
  vpc_security_group_ids = var.vpc_security_group_ids
  name_prefix            = "${local.identifier}-"
  user_data              = var.ssm_agent_enabled ? filebase64("${path.module}/templates/ssm_agent.sh.tpl") : null

  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings

    content {
      device_name = block_device_mappings.value.device_name

      ebs {

        delete_on_termination = lookup(block_device_mappings.value, "delete_on_termination", null)
        encrypted             = lookup(block_device_mappings.value, "encrypted", null)
        iops                  = lookup(block_device_mappings.value, "iops", null)
        kms_key_id            = lookup(block_device_mappings.value, "kms_key_id", null)
        snapshot_id           = lookup(block_device_mappings.value, "snapshot_id", null)
        throughput            = lookup(block_device_mappings.value, "throughput", null)
        volume_size           = lookup(block_device_mappings.value, "volume_size", null)
        volume_type           = lookup(block_device_mappings.value, "volume_type", null)
      }
    }
  }

  metadata_options {
    http_put_response_hop_limit = var.metadata_options.http_put_response_hop_limit
    http_endpoint               = var.metadata_options.http_endpoint
    http_tokens                 = var.metadata_options.http_tokens
  }

  dynamic "tag_specifications" {
    for_each = var.tag_resource_types
    content {
      resource_type = tag_specifications.value
      tags          = local.tags
    }
  }

  tags = local.tags
}
