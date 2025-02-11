# Create a Log Group
module "log_group" {
  source            = "github.com/nclouds/terraform-aws-cloudwatch?ref=v0.1.17"
  identifier        = var.identifier
  retention_in_days = 1
  tags              = var.tags
}

# Create a Task Execution Role
module "task_role" {
  source = "github.com/nclouds/terraform-aws-iam-role?ref=v1.0.2"
  iam_policies_to_attach = [
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite",
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]
  trusted_service_arns = ["ecs-tasks.amazonaws.com"]
  identifier           = "${var.identifier}-task-role"
  tags                 = var.tags
}

# Create a Task Definition
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
  tags                         = var.tags
  execution_role_arn           = module.task_role.output.role.arn
  task_role_arn                = module.task_role.output.role.arn
  container_memory             = 256
  container_memory_reservation = 128
  container_cpu                = 10
  essential                    = true
  environment = [
    {
      "name" : "ENVIRONMENT",
      "value" : "PROD"
    }
  ]
  log_configuration = {

    "logDriver" : "awslogs",
    "options" : {
      "awslogs-group" : module.log_group.output.log_group.name,
      "awslogs-region" : "us-east-1",
      "awslogs-stream-prefix" : "ecs"
    }
  }
}
