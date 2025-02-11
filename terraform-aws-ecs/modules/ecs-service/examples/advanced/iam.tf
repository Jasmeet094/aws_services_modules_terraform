# IAM ROLE for Container Instances
module "container_instance_role" {
  source = "github.com/nclouds/terraform-aws-iam-role?ref=v1.0.2"
  iam_policies_to_attach = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  ]
  trusted_service_arns = ["ec2.amazonaws.com"]
  identifier           = "${var.identifier}-container-instance-role"
  tags                 = var.tags
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