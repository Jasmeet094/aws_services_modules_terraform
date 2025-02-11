locals {
  tags = merge(module.common_tags.output, var.tags)
}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags?ref=v0.1.2"
  environment = terraform.workspace
}

#tfsec:ignore:aws-cloudwatch-log-group-customer-key
module "log_group" {
  count = var.cloudwatch_logs_enabled ? 1 : 0

  source = "github.com/nclouds/terraform-aws-cloudwatch.git?ref=v0.1.17"

  retention_in_days = var.cloudwatch_logs_retention_in_days
  append_workspace  = false
  identifier        = var.cloudwatch_logs_group_name
  tags              = merge(local.tags, { "Name" : var.cloudwatch_logs_group_name })
}

module "cloudwatch_delivery_iam_role" {
  count  = var.cloudwatch_logs_enabled ? 1 : 0
  source = "github.com/nclouds/terraform-aws-iam-role.git?ref=v1.0.2"

  identifier  = var.iam_role_name
  description = "IAM Role to deliver CloudTrail Logs to Cloudwatch"

  iam_policies_to_attach = [
    module.cloudwatch_delivery_iam_policy[0].output.policy.arn
  ]

  tags = merge(local.tags, { "Name" : var.iam_role_name })

  trusted_service_arns = ["cloudtrail.amazonaws.com"]
}

#tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "cloudwatch_delivery_policy" {
  count = var.cloudwatch_logs_enabled ? 1 : 0

  statement {
    sid       = "AWSCloudTrailCreateLogStream2014110"
    actions   = ["logs:CreateLogStream"]
    resources = ["arn:aws:logs:${var.region}:${var.aws_account_id}:log-group:${module.log_group[0].output.log_group.name}:log-stream:*"]
  }

  statement {
    sid       = "AWSCloudTrailPutLogEvents20141101"
    actions   = ["logs:PutLogEvents"]
    resources = ["arn:aws:logs:${var.region}:${var.aws_account_id}:log-group:${module.log_group[0].output.log_group.name}:log-stream:*"]
  }
}

module "cloudwatch_delivery_iam_policy" {
  count           = var.cloudwatch_logs_enabled ? 1 : 0
  source          = "github.com/nclouds/terraform-aws-iam-policy.git?ref=v0.1.11"
  identifier      = var.iam_role_policy_name
  rendered_policy = data.aws_iam_policy_document.cloudwatch_delivery_policy[0].json
}

data "aws_iam_policy_document" "cloudtrail_key_policy" {
  policy_id = "Key policy created by CloudTrail"

  statement {
    sid = "Enable IAM User Permissions"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${var.aws_account_id}:root"
      ]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid = "Allow CloudTrail to encrypt logs"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = ["kms:GenerateDataKey*"]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = ["arn:aws:cloudtrail:*:${var.aws_account_id}:trail/*"]
    }
  }

  statement {
    sid = "Allow CloudTrail to describe key"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = ["kms:DescribeKey"]
    resources = ["*"]
  }

  statement {
    sid = "Allow principals in the account to decrypt log files"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "kms:Decrypt",
      "kms:ReEncryptFrom"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = ["${var.aws_account_id}"]
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = ["arn:aws:cloudtrail:*:${var.aws_account_id}:trail/*"]
    }
  }

  statement {
    sid = "Allow alias creation during setup"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["kms:CreateAlias"]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = ["ec2.${var.region}.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = ["${var.aws_account_id}"]
    }
  }

  statement {
    sid = "Enable cross account log decryption"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "kms:Decrypt",
      "kms:ReEncryptFrom"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = ["${var.aws_account_id}"]
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = ["arn:aws:cloudtrail:*:${var.aws_account_id}:trail/*"]
    }
  }

  # https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-permissions-for-sns-notifications.html
  statement {
    sid = "Allow CloudTrail to send notifications to the encrypted SNS topic"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions = [
      "kms:GenerateDataKey*",
      "kms:Decrypt"
    ]
    resources = ["*"]
  }
}

module "kms" {
  source = "github.com/nclouds/terraform-aws-kms.git?ref=v0.1.5"

  append_workspace = false
  deletion_window  = var.key_deletion_window_in_days
  description      = "A KMS key to encrypt CloudTrail events."
  identifier       = var.cloudtrail_name
  policy           = data.aws_iam_policy_document.cloudtrail_key_policy.json
  tags             = merge(local.tags, { "Name" : var.cloudtrail_name })
}

resource "aws_sns_topic" "cloudtrail-sns-topic" {
  count = var.cloudtrail_sns_topic_enabled ? 1 : 0

  name              = var.cloudtrail_sns_topic_name
  kms_master_key_id = module.kms.output.key_id
  tags              = merge(local.tags, { "Name" : var.cloudtrail_sns_topic_name })
}

data "aws_iam_policy_document" "cloudtrail-sns-policy" {
  count = var.cloudtrail_sns_topic_enabled ? 1 : 0

  statement {
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.cloudtrail-sns-topic[0].arn]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

resource "aws_sns_topic_policy" "local-account-cloudtrail" {
  count = var.cloudtrail_sns_topic_enabled ? 1 : 0

  arn    = aws_sns_topic.cloudtrail-sns-topic[0].arn
  policy = data.aws_iam_policy_document.cloudtrail-sns-policy[0].json
}

resource "aws_cloudtrail" "global" {
  name = var.cloudtrail_name

  cloud_watch_logs_group_arn    = var.cloudwatch_logs_enabled ? "${module.log_group[0].output.log_group.arn}:*" : null
  cloud_watch_logs_role_arn     = var.cloudwatch_logs_enabled ? module.cloudwatch_delivery_iam_role[0].output.role.arn : null
  enable_log_file_validation    = true
  include_global_service_events = true
  is_multi_region_trail         = true
  is_organization_trail         = var.is_organization_trail
  kms_key_id                    = module.kms.output.key_arn
  s3_bucket_name                = var.s3_bucket_name
  s3_key_prefix                 = var.s3_key_prefix
  sns_topic_name                = var.cloudtrail_sns_topic_enabled ? aws_sns_topic.cloudtrail-sns-topic[0].arn : null

  tags = merge(local.tags, { "Name" : var.cloudtrail_name })
}
