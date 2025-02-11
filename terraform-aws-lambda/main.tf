locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier
  tags       = merge(module.common_tags.output, var.tags)
}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags.git?ref=v0.1.2"
  environment = terraform.workspace
  name        = local.identifier
}

#tfsec:ignore:aws-cloudwatch-log-group-customer-key
module "log_group" {
  source = "github.com/nclouds/terraform-aws-cloudwatch.git?ref=v0.1.18"

  retention_in_days  = var.log_retention_in_days
  use_custom_kms_key = var.log_group_use_custom_kms_key
  append_workspace   = false
  use_name_prefix    = false
  kms_key_id         = var.log_group_kms_key_id
  identifier         = "/aws/lambda/${local.identifier}"
  tags               = local.tags
}

#tfsec:ignore:aws-lambda-enable-tracing
resource "aws_lambda_function" "function" {
  reserved_concurrent_executions = var.reserved_concurrent_executions
  source_code_hash               = var.source_code_hash
  function_name                  = local.identifier
  description                    = var.description
  memory_size                    = var.memory_size
  handler                        = var.handler
  publish                        = var.publish
  runtime                        = var.runtime
  timeout                        = var.timeout
  layers                         = var.layers
  role                           = var.iam_role

  filename = var.filename

  s3_bucket = var.s3_bucket
  s3_key    = var.s3_key

  dynamic "environment" {
    for_each = length(var.environment) > 0 ? [1] : []
    content {
      variables = var.environment
    }
  }

  vpc_config {
    security_group_ids = var.security_group_ids
    subnet_ids         = var.subnet_ids
  }

  dynamic "dead_letter_config" {
    for_each = var.sns_topic_arn == null ? [] : [1]
    content {
      target_arn = var.sns_topic_arn
    }
  }

  depends_on = [module.log_group]

  tags = local.tags
}

resource "aws_lambda_event_source_mapping" "trigger" {
  count = var.create_trigger ? 1 : 0

  event_source_arn = var.event_source_arn
  function_name    = aws_lambda_function.function.arn
}
