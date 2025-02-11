# WORKERS USER DATA
locals {
  container_instance_userdata = <<USERDATA
#!/bin/bash
# Set any ECS agent configuration options
echo "ECS_CLUSTER=${module.ecs.output.cluster.name}" >> /etc/ecs/ecs.config
USERDATA
}
