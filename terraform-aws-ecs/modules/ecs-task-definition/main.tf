locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier

  tags = merge(module.common_tags.output, var.tags)

  container_list = "[${join(",", concat([module.container_definition.output], var.container_definitions))}]"
}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags?ref=v0.1.2"
  environment = terraform.workspace
  name        = local.identifier
}

module "container_definition" {
  source = "../ecs-container-definition"

  container_memory_reservation = var.container_memory_reservation
  readonly_root_filesystem     = var.readonly_root_filesystem
  firelens_configuration       = var.firelens_configuration
  log_configuration            = var.log_configuration
  container_memory             = var.container_memory
  append_workspace             = var.append_workspace_container
  system_controls              = var.system_controls
  container_image              = var.container_image
  container_cpu                = var.container_cpu
  docker_labels                = var.docker_labels
  port_mappings                = var.port_mappings
  start_timeout                = var.start_timeout
  mount_points                 = var.mount_points
  stop_timeout                 = var.stop_timeout
  volumes_from                 = var.volumes_from
  dns_servers                  = var.dns_servers
  environment                  = var.environment
  entrypoint                   = var.entrypoint
  identifier                   = var.identifier
  essential                    = var.essential
  command                      = var.command
  secrets                      = var.secrets
  ulimits                      = var.ulimits
  links                        = var.links
}

resource "aws_ecs_task_definition" "task" {
  requires_compatibilities = var.requires_compatibilities
  container_definitions    = local.container_list
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn
  network_mode             = var.network_mode
  family                   = local.identifier
  memory                   = var.task_memory
  cpu                      = var.task_cpu

  dynamic "volume" {
    for_each = var.volume
    content {
      name      = volume.value.name
      host_path = volume.value.host_path

      dynamic "efs_volume_configuration" {
        for_each = lookup(volume.value, "efs_volume_configuration", null) != null ? [1] : []
        content {
          file_system_id = volume.value.efs_volume_configuration.file_system_id
          root_directory = volume.value.efs_volume_configuration.root_directory
        }
      }

      dynamic "docker_volume_configuration" {
        for_each = lookup(volume.value, "docker_volume_configuration", null) != null ? [1] : []
        content {
          scope         = volume.value.docker_volume_configuration.scope
          autoprovision = volume.value.docker_volume_configuration.autoprovision
          driver        = volume.value.docker_volume_configuration.driver
          driver_opts   = volume.value.docker_volume_configuration.driver_opts
          labels        = volume.value.docker_volume_configuration.labels
        }
      }
    }
  }

  tags = local.tags
}
