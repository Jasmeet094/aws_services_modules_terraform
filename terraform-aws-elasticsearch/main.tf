data "aws_region" "current" {}

locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier
  tags       = merge(module.common_tags.output, var.tags)
}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags?ref=v0.1.2"
  environment = terraform.workspace
  name        = local.identifier
}

data "aws_iam_policy_document" "elasticsearch-log-publishing-policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
    ]

    resources = ["arn:aws:logs:*"]

    principals {
      identifiers = ["es.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "elasticsearch-log-publishing-policy" {
  policy_document = data.aws_iam_policy_document.elasticsearch-log-publishing-policy.json
  policy_name     = "${local.identifier}-log-publishing-policy"
}

resource "aws_elasticsearch_domain" "es_domain" {
  elasticsearch_version = var.elasticsearch_version
  # tflint-ignore: aws_elasticsearch_domain_invalid_domain_name
  domain_name = local.identifier

  access_policies = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "es:*",
        "Principal": "*",
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  POLICY

  ebs_options {
    ebs_enabled = var.ebs_enabled
    volume_type = var.volume_type
    volume_size = var.volume_size
    iops        = var.iops
  }

  domain_endpoint_options {
    enforce_https       = var.enforce_https
    tls_security_policy = var.tls_security_policy
  }

  node_to_node_encryption {
    enabled = var.encryption_in_transit
  }

  advanced_security_options {
    enabled                        = var.advanced_security
    internal_user_database_enabled = var.internal_db
    master_user_options {
      master_user_name     = var.master_user
      master_user_password = var.master_password != null ? "T0p$ecret" : var.master_password
    }
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.es_logs.arn
    log_type                 = "AUDIT_LOGS"
    enabled                  = var.log_publish
  }

  encrypt_at_rest {
    enabled = var.encryption_at_rest
  }

  cluster_config {
    dedicated_master_enabled = var.dedicated_master_enabled
    dedicated_master_count   = var.dedicated_master_count
    zone_awareness_enabled   = var.zone_awareness_enabled
    dedicated_master_type    = var.dedicated_master_type
    instance_count           = var.instance_count
    instance_type            = var.instance_type
  }

  snapshot_options {
    automated_snapshot_start_hour = var.automated_snapshot_start_hour
  }

  vpc_options {
    security_group_ids = var.security_group_ids
    subnet_ids         = var.subnets_ids
  }

  tags = local.tags
}

module "kms" {
  source = "github.com/nclouds/terraform-aws-kms.git?ref=v0.1.5"

  append_workspace = false
  deletion_window  = 30
  description      = "KMS key for ${local.identifier} logs"
  identifier       = local.identifier
  policy           = <<EOF
{
  "Version" : "2012-10-17",
  "Id" : "key-default-1",
  "Statement" : [ {
      "Sid" : "Enable IAM User Permissions",
      "Effect" : "Allow",
      "Principal" : {
        "AWS" : "*"
      },
      "Action" : "kms:*",
      "Resource" : "*"
    },
    {
      "Effect": "Allow",
      "Principal": { "Service": "logs.${data.aws_region.current.name}.amazonaws.com" },
      "Action": [ 
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ],
      "Resource": "*"
    }  
  ]
}
EOF
  tags             = local.tags
}

resource "aws_cloudwatch_log_group" "es_logs" {
  name       = "${local.identifier}-log-group"
  kms_key_id = module.kms.output.key_arn
  tags       = local.tags
}
