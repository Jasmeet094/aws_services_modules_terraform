data "aws_caller_identity" "current" {}

## kms policy
data "aws_iam_policy_document" "kms_owner" {
  statement {
    sid    = "key owner"
    effect = "Allow"
    actions = [
      "kms:*",
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "cloudwatch_logs" {
  statement {
    sid    = "allow cloudwatch logs to use this key"
    effect = "Allow"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*",
    ]
    principals {
      type        = "Service"
      identifiers = ["logs.${var.region}.amazonaws.com"]
    }
    resources = ["*"]
    condition {
      test     = "ArnLike"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values = [
        "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:*",
      ]
    }
  }
}

data "aws_iam_policy_document" "combined" {
  source_policy_documents = [
    data.aws_iam_policy_document.kms_owner.json,
    data.aws_iam_policy_document.cloudwatch_logs.json,
  ]
}