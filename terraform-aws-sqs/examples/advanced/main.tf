data "aws_caller_identity" "current" {}

#tfsec:ignore:aws-sns-enable-topic-encryption
resource "aws_sns_topic" "topic" {
  name = var.identifier
}

data "aws_iam_policy_document" "sqs" {
  statement {
    sid    = "SQSSendMessage"
    effect = "Allow"
    actions = [
      "sqs:SendMessage",
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    resources = ["*"]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = ["${aws_sns_topic.topic.arn}"]
    }

  }
}

# Create SQS Queue
module "sqs" {
  source                        = "../.."
  identifier                    = var.identifier
  dead_letter_queue             = true
  delay_seconds                 = 60
  message_retention_seconds     = 86400
  message_retention_seconds_dlq = 86400
  max_receive_count             = 1
  content_based_deduplication   = true

  policy = data.aws_iam_policy_document.sqs.json

  fifo_queue = true

}
