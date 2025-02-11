#tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "document" {
  statement {
    actions   = local.policies["logs_admin"]["actions"]
    resources = local.policies["logs_admin"]["resources"]
  }
}

#### Use this locals to define the policies you want to use, pass the name of the policy definition to the module so it can render it for you.
locals {
  policies = {
    logs_admin = {
      actions = [
        "logs:*"
      ],
      resources = [
        "*",
      ]
    }
  }
}