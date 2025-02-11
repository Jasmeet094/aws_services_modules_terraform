#tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "document_cw" {
  statement {
    actions   = local.policies["logs_admin"]["actions"]
    resources = local.policies["logs_admin"]["resources"]
  }
}

#tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "document_ec2" {
  statement {
    actions   = local.policies["ec2_admin"]["actions"]
    resources = local.policies["ec2_admin"]["resources"]
  }
}

#tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "document_sqs" {
  statement {
    actions   = local.policies["sqs_admin"]["actions"]
    resources = local.policies["sqs_admin"]["resources"]
  }
}

#### Use this locals to define the policies you want to use, pass the name of the policy definition to the module so it can render it for you.
locals {
  policies = {
    logs = {
      actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      resources = [
        "*",
      ]
    }
    logs_admin = {
      actions = [
        "logs:*"
      ],
      resources = [
        "*",
      ]
    },
    ec2_admin = {
      actions = [
        "ec2:*"
      ],
      resources = [
        "*",
      ]
    },
    sqs_admin = {
      actions = [
        "sqs:*"
      ],
      resources = [
        "*",
      ]
    }
  }
}