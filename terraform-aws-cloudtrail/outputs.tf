output "output" {
  value = {
    cloudtrail            = aws_cloudtrail.global
    cloudtrail_sns_topic  = var.cloudtrail_sns_topic_enabled ? aws_sns_topic.cloudtrail-sns-topic[0] : null
    kms_key               = module.kms.output
    log_delivery_iam_role = var.cloudwatch_logs_enabled ? module.cloudwatch_delivery_iam_role[0].output.role.arn : null
    log_group             = var.cloudwatch_logs_enabled ? module.log_group[0].output.log_group : null
  }
}
