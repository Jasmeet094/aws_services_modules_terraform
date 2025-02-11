locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier
  tags       = merge(module.common_tags.output, var.tags)
}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags?ref=v0.1.2"
  environment = terraform.workspace
  name        = local.identifier
}

resource "aws_ecs_capacity_provider" "worker_capacity_provider" {
  name = local.identifier

  auto_scaling_group_provider {
    managed_termination_protection = var.managed_termination_protection
    auto_scaling_group_arn         = var.auto_scaling_group_arn

    managed_scaling {
      maximum_scaling_step_size = var.max_scale_step
      minimum_scaling_step_size = var.min_scale_step
      target_capacity           = var.target_capacity
      status                    = var.scaling_status
    }
  }

  tags = local.tags
}
