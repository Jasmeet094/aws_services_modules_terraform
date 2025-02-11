data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_elb_service_account" "main" {}

data "aws_s3_bucket" "selected" {
  count = var.bucket_name != "" ? 1 : 0

  bucket = var.bucket_name
}

data "aws_iam_policy_document" "access_alb_logs" {
  count = var.alb_access_logs_enable ? 1 : 0

  statement {
    sid = "AccessForALB"

    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.main.arn]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${var.bucket_name == "" ? aws_s3_bucket.lb_logs[0].arn : data.aws_s3_bucket.selected[0].arn}/*" #${var.bucket_logs_prefix}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
    ]
  }

  statement {
    sid = "AWSLogDeliveryWrite"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${var.bucket_name == "" ? aws_s3_bucket.lb_logs[0].arn : data.aws_s3_bucket.selected[0].arn}/*" #${var.bucket_logs_prefix}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "bucket-owner-full-control",
      ]
    }
  }

  statement {
    sid = "AWSLogDeliveryAclCheck"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl"
    ]

    resources = [
      var.bucket_name == "" ? aws_s3_bucket.lb_logs[0].arn : data.aws_s3_bucket.selected[0].arn,
    ]
  }
}
