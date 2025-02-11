data "aws_iam_policy_document" "document" {
  statement {
    actions   = ["s3:GetBucketAcl"]
    resources = [module.s3.output.bucket.arn]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    effect = "Allow"
  }

  statement {
    actions   = ["s3:PutObject"]
    resources = ["${module.s3.output.bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    effect = "Allow"
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = module.s3.output.bucket.id
  policy = data.aws_iam_policy_document.document.json
}