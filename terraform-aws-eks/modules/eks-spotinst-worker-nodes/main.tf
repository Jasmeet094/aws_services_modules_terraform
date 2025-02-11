locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier
  tags       = merge(module.common_tags.output, var.tags)
}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags?ref=v0.1.2"
  environment = terraform.workspace
  name        = local.identifier
}

data "aws_ssm_parameter" "eks_optimized_ami" {
  name = "/aws/service/eks/optimized-ami/${var.kubernetes_version}/amazon-linux-2/recommended/image_id"
}

resource "spotinst_ocean_aws" "ocean" {
  associate_public_ip_address = var.associate_public_ip_address
  utilize_reserved_instances  = false
  fallback_to_ondemand        = false
  iam_instance_profile        = var.iam_instance_profile
  desired_capacity            = var.desired_capacity
  draining_timeout            = 120
  root_volume_size            = var.root_volume_size
  security_groups             = var.security_groups
  spot_percentage             = 100
  controller_id               = var.cluster_name
  subnet_ids                  = var.subnet_ids
  whitelist                   = var.instance_types
  image_id                    = data.aws_ssm_parameter.eks_optimized_ami.value
  key_name                    = var.key_name
  max_size                    = var.max_size
  min_size                    = var.min_size
  region                      = var.region
  name                        = local.identifier

  user_data = <<EOT
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh ${var.cluster_name}
EOT

  autoscaler {
    autoscale_is_auto_config = false
    autoscale_is_enabled     = false
    autoscale_cooldown       = 300

    autoscale_headroom {
      memory_per_unit = 512
      cpu_per_unit    = 1024
      num_of_units    = 2
    }

    autoscale_down {
      evaluation_periods = 300
    }

    resource_limits {
      max_memory_gib = 20
      max_vcpu       = 1024
    }
  }

  dynamic "tags" {
    for_each = local.tags

    content {
      value = tags.value
      key   = tags.key
    }
  }

  tags {
    key   = "kubernetes.io/cluster/${var.cluster_name}"
    value = "owned"
  }
}
