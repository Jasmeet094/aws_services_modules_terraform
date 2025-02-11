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

data "aws_iam_policy_document" "document" {
  statement {
    actions   = local.policies["logs_admin"]["actions"]
    resources = local.policies["logs_admin"]["resources"]
  }
}

module "iam_policy" {
  source          = "../"
  identifier      = "example-iam-policy"
  rendered_policy = data.aws_iam_policy_document.document.json
}