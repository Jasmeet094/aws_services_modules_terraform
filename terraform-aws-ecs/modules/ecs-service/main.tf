locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier
  tags       = merge(module.common_tags.output, var.tags)
}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags?ref=v0.1.2"
  environment = terraform.workspace
  name        = local.identifier
}

resource "aws_ecs_service" "service" {
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent
  enable_ecs_managed_tags            = var.enable_ecs_managed_tags
  enable_execute_command             = var.enable_execute_command
  scheduling_strategy                = var.scheduling_strategy
  task_definition                    = var.task_definition
  desired_count                      = var.desired_count
  propagate_tags                     = var.propagate_tags
  launch_type                        = var.launch_type
  cluster                            = var.cluster
  name                               = local.identifier

  dynamic "load_balancer" {
    for_each = var.load_balancer_configurations
    content {
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
    }
  }

  dynamic "ordered_placement_strategy" {
    for_each = var.scheduling_strategy != "DAEMON" ? var.ordered_placement_strategies : []
    content {
      type  = ordered_placement_strategy.value.type
      field = ordered_placement_strategy.value.field
    }
  }

  dynamic "capacity_provider_strategy" {
    for_each = var.capacity_provider != "" ? [1] : []
    content {
      capacity_provider = var.capacity_provider
      weight            = 100
    }
  }

  dynamic "network_configuration" {
    for_each = length(var.subnets) > 0 ? [1] : []
    content {
      subnets          = var.subnets
      security_groups  = var.security_groups
      assign_public_ip = var.assign_public_ip
    }
  }

  lifecycle {
    ignore_changes = [
      desired_count
    ]
  }

  tags = local.tags
}
