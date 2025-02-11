# Create a Security Group
module "eks_security_group" {
  source     = "github.com/nclouds/terraform-aws-security-group?ref=v0.2.9"
  identifier = "${var.identifier}-eks"
  vpc_id     = module.vpc.output.vpc.id
}