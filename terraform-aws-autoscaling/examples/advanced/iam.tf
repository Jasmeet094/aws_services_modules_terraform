# Create an IAM Role
module "example_role" {
  source                 = "github.com/nclouds/terraform-aws-iam-role?ref=v1.0.2"
  description            = "Example IAM Role"
  iam_policies_to_attach = []
  trusted_service_arns   = ["ec2.amazonaws.com"]
  identifier             = "${var.identifier}-role"
}
