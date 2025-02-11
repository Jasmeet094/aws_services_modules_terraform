# Create ECS Instance Security Group
module "ecs_security_group" {
  source     = "github.com/nclouds/terraform-aws-security-group?ref=v0.2.9"
  identifier = "${var.identifier}-ecs-security-group"
  vpc_id     = var.create_vpc ? module.vpc[0].output.vpc.id : "vpc-000fe2b5ddba6bb64"
  tags       = var.tags
}