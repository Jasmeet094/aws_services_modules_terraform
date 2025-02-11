module "ecs_task_definition" {
  source          = "../.."
  identifier      = var.identifier
  container_image = "nginx"
  port_mappings = [
    {
      containerPort = 80
      hostPort      = 0
      protocol      = "tcp"
    }
  ]
  tags = var.tags
}
