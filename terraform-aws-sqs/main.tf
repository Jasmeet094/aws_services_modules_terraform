locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier

  redrive_policy = var.dead_letter_queue ? jsonencode({ deadLetterTargetArn = aws_sqs_queue.dead_letter_queue[0].arn, maxReceiveCount = var.max_receive_count }) : null
  suffix         = var.fifo_queue ? ".fifo" : ""
  tags           = merge(module.common_tags.output, var.tags)
}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags.git?ref=v0.1.2"
  environment = terraform.workspace
  name        = local.identifier
}

#tfsec:ignore:aws-sqs-enable-queue-encryption
resource "aws_sqs_queue" "main" {
  content_based_deduplication = var.fifo_queue ? var.content_based_deduplication : false
  visibility_timeout_seconds  = var.visibility_timeout_seconds
  message_retention_seconds   = var.message_retention_seconds
  receive_wait_time_seconds   = var.receive_wait_time_seconds
  kms_master_key_id           = var.kms_master_key_id #tfsec:ignore:aws-sqs-queue-encryption-use-cmk
  max_message_size            = var.max_message_size
  redrive_policy              = local.redrive_policy
  delay_seconds               = var.delay_seconds
  fifo_queue                  = var.fifo_queue
  policy                      = var.policy
  name                        = "${local.identifier}${local.suffix}"

  tags = local.tags
}

#tfsec:ignore:aws-sqs-enable-queue-encryption
resource "aws_sqs_queue" "dead_letter_queue" {
  count = var.dead_letter_queue ? 1 : 0

  message_retention_seconds = var.message_retention_seconds_dlq
  receive_wait_time_seconds = var.receive_wait_time_seconds
  kms_master_key_id         = var.kms_master_key_id
  max_message_size          = var.max_message_size
  delay_seconds             = var.delay_seconds
  fifo_queue                = var.fifo_queue
  policy                    = var.policy
  name                      = "${local.identifier}-DeadLetterQueue${local.suffix}"

  tags = local.tags
}
