locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier
  tags       = merge(module.common_tags.output, var.tags)
}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags?ref=v0.1.2"
  environment = terraform.workspace
  name        = local.identifier
}

resource "aws_security_group" "default" {
  description = var.description
  vpc_id      = var.vpc_id
  name        = local.identifier

  tags = local.tags
}

resource "aws_security_group_rule" "default_ingress_rules" {
  count = length(var.ingress_rule_list)

  security_group_id = aws_security_group.default.id
  cidr_blocks       = var.ingress_rule_list[count.index].cidr_blocks
  description       = var.ingress_rule_list[count.index].description #tfsec:ignore:AWS018
  from_port         = var.ingress_rule_list[count.index].from_port
  protocol          = var.ingress_rule_list[count.index].protocol
  to_port           = var.ingress_rule_list[count.index].to_port
  type              = "ingress"
}

resource "aws_security_group_rule" "default_security_group_ingress_rules" {
  count = length(var.ingress_from_security_group_list)

  security_group_id        = aws_security_group.default.id
  source_security_group_id = var.ingress_from_security_group_list[count.index].source_security_group_id
  description              = var.ingress_from_security_group_list[count.index].description #tfsec:ignore:AWS018
  from_port                = var.ingress_from_security_group_list[count.index].from_port
  protocol                 = var.ingress_from_security_group_list[count.index].protocol
  to_port                  = var.ingress_from_security_group_list[count.index].to_port
  type                     = "ingress"
}

resource "aws_security_group_rule" "self" {
  count = var.self_rule ? 1 : 0

  security_group_id = aws_security_group.default.id
  description       = "Managed by terraform"
  from_port         = 0
  protocol          = "all"
  to_port           = 65535
  self              = true
  type              = "ingress"
}

#tfsec:ignore:aws-ec2-no-public-ingress-sgr
#tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "default_egress_rules" {
  count = length(var.egress_rule_list)

  security_group_id = aws_security_group.default.id
  cidr_blocks       = var.egress_rule_list[count.index].cidr_blocks #tfsec:ignore:AWS007
  description       = var.egress_rule_list[count.index].description #tfsec:ignore:AWS018
  from_port         = var.egress_rule_list[count.index].from_port
  protocol          = var.egress_rule_list[count.index].protocol
  to_port           = var.egress_rule_list[count.index].to_port
  type              = "egress"
}
