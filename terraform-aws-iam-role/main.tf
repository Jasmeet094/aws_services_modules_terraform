locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier
  tags       = merge(module.common_tags.output, var.tags)
}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags.git?ref=v0.1.2"
  environment = terraform.workspace
  name        = local.identifier
}

resource "aws_iam_instance_profile" "profile" {
  name = local.identifier
  role = aws_iam_role.role.name
  tags = local.tags
}

resource "aws_iam_role" "role" {
  force_detach_policies = true
  assume_role_policy    = local.assume_role_policy
  description           = var.description
  name                  = local.identifier
  tags                  = local.tags
}

resource "aws_iam_role_policy_attachment" "attach" {
  count = length(var.iam_policies_to_attach)

  policy_arn = element(var.iam_policies_to_attach, count.index)
  role       = aws_iam_role.role.name
}
