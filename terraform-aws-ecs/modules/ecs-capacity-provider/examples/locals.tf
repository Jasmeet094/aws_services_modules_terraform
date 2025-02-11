# WORKERS USER DATA
locals {
  container_instance_userdata = <<USERDATA
#!/bin/bash
# Set any ECS agent configuration options
echo "ECS_CLUSTER=${var.identifier}-${terraform.workspace}" >> /etc/ecs/ecs.config
USERDATA
}