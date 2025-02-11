# Create a Security Group
module "alb_security_group" {
  source     = "github.com/nclouds/terraform-aws-security-group?ref=v0.2.9"
  identifier = "${var.identifier}-alb-security-group"
  vpc_id     = var.create_vpc ? module.vpc[0].output.vpc.id : "vpc-000fe2b5ddba6bb64"
  tags       = var.tags
  ingress_rule_list = [
    {
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow ELB Traffic from Everywhere"
      from_port   = var.lb_port
      protocol    = "tcp"
      to_port     = var.lb_port
    }
  ]
}

# Create ECS Instance Security Group
module "ecs_security_group" {
  source     = "git@github.com:nclouds/terraform-aws-security-group.git?ref=v0.2.9"
  identifier = "${var.identifier}-ecs-security-group"
  vpc_id     = var.create_vpc ? module.vpc[0].output.vpc.id : "vpc-000fe2b5ddba6bb64"
  tags       = var.tags
}

# SG Inbound Rule
resource "aws_security_group_rule" "allow_ingress_from_alb" {
  description              = "Allow Ingress from Load Balancer"
  type                     = "ingress"
  to_port                  = 65535
  protocol                 = "tcp"
  from_port                = 10240
  security_group_id        = module.ecs_security_group.output.security_group.id
  source_security_group_id = module.alb_security_group.output.security_group.id
}