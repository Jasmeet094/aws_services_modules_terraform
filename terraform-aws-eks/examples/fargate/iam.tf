# IAM ROLE for Workers
module "fargate_profile_role" {
  source = "github.com/nclouds/terraform-aws-iam-role?ref=v1.0.2"
  iam_policies_to_attach = [
    "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  ]
  trusted_service_arns = ["eks-fargate-pods.amazonaws.com"]
  identifier           = "${var.identifier}-fargate"
}