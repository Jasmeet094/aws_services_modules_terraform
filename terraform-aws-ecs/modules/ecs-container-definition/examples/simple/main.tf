// Container definition module
module "auxiliary_container_definition" {
  source = "../.."

  container_image = "redis"
  identifier      = "redis"
}

// Task definition module
module "ecs_task_definition" {
  source = "../../../ecs-task-definition"

  container_definitions = [module.auxiliary_container_definition.output] //Reference additional container module here
  container_image       = "nginx"
  identifier            = "example"
  tags                  = var.tags
}
