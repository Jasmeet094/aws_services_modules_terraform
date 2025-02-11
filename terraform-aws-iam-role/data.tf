data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

data "aws_iam_policy_document" "default" {
  count = length(var.oidc_fully_qualified_subjects) > 0 ? 0 : 1

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = var.trusted_iam_arns
    }

    principals {
      type        = "Service"
      identifiers = var.trusted_service_arns
    }
  }
}

data "aws_iam_policy_document" "oidc" {
  count = length(var.oidc_fully_qualified_subjects) > 0 ? 1 : 0

  dynamic "statement" {
    for_each = local.urls

    content {
      effect  = "Allow"
      actions = ["sts:AssumeRoleWithWebIdentity"]

      principals {
        type        = "Federated"
        identifiers = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${statement.value}"]
      }

      dynamic "condition" {
        for_each = length(var.oidc_fully_qualified_subjects) > 0 ? local.urls : []

        content {
          test     = "StringEquals"
          variable = "${statement.value}:sub"
          values   = var.oidc_fully_qualified_subjects
        }
      }
    }
  }
}