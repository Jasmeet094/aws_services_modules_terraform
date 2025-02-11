module "s3-bucket" {
  source        = "github.com/nclouds/terraform-aws-s3-bucket?ref=v0.2.6"
  force_destroy = "true"
  identifier    = "${var.identifier}-s3-bucket-for-flow-logs-123"
}

module "vpc" {
  source = "../.."

  multi_nat_gw   = true
  disable_nat_gw = false
  flow_log_settings = {
    enable_flow_log          = true
    traffic_type             = "ALL"
    log_destination_type     = "s3"
    logs_retention_in_days   = null
    flow_log_destination_arn = module.s3-bucket.output.bucket.arn
    max_aggregation_interval = 600
    iam_role_arn             = null
  }
  vpc_settings = {
    application_subnets = ["10.10.24.0/22", "10.10.28.0/22", "10.10.32.0/22"]
    public_subnets      = ["10.10.0.0/22", "10.10.4.0/22", "10.10.8.0/22"]
    data_subnets        = ["10.10.12.0/22", "10.10.16.0/22", "10.10.20.0/22"]
    dns_hostnames       = true
    dns_support         = true
    tenancy             = "default"
    cidr                = "10.10.0.0/16"
  }
  identifier = "${var.identifier}_vpc"
  region     = "us-east-1"
}
