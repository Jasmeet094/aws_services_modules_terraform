# Create an IAM Role
module "example_role" {
  source     = "../../"
  identifier = "${var.identifier}-role"
}
