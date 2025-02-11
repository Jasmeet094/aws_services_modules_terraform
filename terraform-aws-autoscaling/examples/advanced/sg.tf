# Create a Security Group
module "security_group" {
  source     = "github.com/nclouds/terraform-aws-security-group?ref=v0.2.9"
  identifier = "${var.identifier}-sg"
  vpc_id     = module.vpc.output.vpc.id
}