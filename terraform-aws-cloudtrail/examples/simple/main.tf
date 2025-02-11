data "aws_caller_identity" "current" {}

module "s3" {
  source        = "github.com/nclouds/terraform-aws-s3-bucket?ref=v0.2.6"
  identifier    = var.identifier
  force_destroy = "true"
}

module "cloudtrail" {
  source          = "../.."
  aws_account_id  = data.aws_caller_identity.current.account_id
  cloudtrail_name = "${var.identifier}-cloudtrail"
  region          = "us-east-1"
  s3_bucket_name  = module.s3.output.bucket.id
}
