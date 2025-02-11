data "aws_caller_identity" "current" {}

module "s3" {
  source        = "github.com/nclouds/terraform-aws-s3-bucket?ref=v0.2.6"
  identifier    = var.identifier
  force_destroy = "true"
}

module "cloudtrail" {
  source                            = "../.."
  aws_account_id                    = data.aws_caller_identity.current.account_id
  cloudtrail_name                   = "${var.identifier}-cloudtrail"
  cloudtrail_sns_topic_enabled      = true
  cloudtrail_sns_topic_name         = "${var.identifier}-cloudtrail-sns-topic"
  cloudwatch_logs_enabled           = true
  cloudwatch_logs_group_name        = "${var.identifier}-cloudtrail-log-group"
  cloudwatch_logs_retention_in_days = 3
  iam_role_name                     = "${var.identifier}-cloudtrail-CloudWatch-Delivery-Role"
  iam_role_policy_name              = "${var.identifier}-cloudtrail-CloudWatch-Delivery-Policy"
  key_deletion_window_in_days       = 7
  region                            = "us-east-1"
  s3_bucket_name                    = module.s3.output.bucket.id
  is_organization_trail             = false
}
