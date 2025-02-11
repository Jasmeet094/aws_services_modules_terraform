output "output" {
  value = {
    log_group = aws_cloudwatch_log_group.this
    kms_arn   = var.use_custom_kms_key ? var.kms_key_id : module.kms[0].output.key_arn
  }
}
