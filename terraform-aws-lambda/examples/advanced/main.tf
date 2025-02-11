#tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "document" {
  statement {
    actions   = local.policies["logs"]["actions"]
    resources = local.policies["logs"]["resources"]
  }
}

module "iam_policy" {
  source = "github.com/nclouds/terraform-aws-iam-policy?ref=v0.1.11"

  rendered_policy = data.aws_iam_policy_document.document.json
  description     = "IAM Policy for VPC Flow Logs Cloudwatch"
  identifier      = "cw-flow-logs-access"
}

module "flow_logs_role" {
  source = "github.com/nclouds/terraform-aws-iam-role?ref=v1.0.2"

  iam_policies_to_attach = [
    module.iam_policy.output.policy.arn
  ]

  trusted_service_arns = ["vpc-flow-logs.amazonaws.com"]
  description          = "Example IAM Role"
  identifier           = "${var.identifier}-flow-logs"
}

# Create a VPC
module "vpc" {
  source       = "git@github.com:nclouds/terraform-aws-vpc.git?ref=v0.3.1"
  multi_nat_gw = false
  flow_log_settings = {
    max_aggregation_interval = 600
    flow_log_destination_arn = null
    logs_retention_in_days   = 30
    log_destination_type     = "cloud-watch-logs"
    enable_flow_log          = true
    iam_role_arn             = module.flow_logs_role.output.role.arn
    traffic_type             = "ALL"
  }
  vpc_settings = {
    application_subnets = ["10.10.16.0/22", "10.10.20.0/22"]
    public_subnets      = ["10.10.0.0/22", "10.10.4.0/22"]
    dns_hostnames       = true
    data_subnets        = []
    dns_support         = true
    tenancy             = "default"
    cidr                = "10.10.0.0/16"
  }
  identifier = "${var.identifier}_vpc"
  region     = "us-east-1"
}

# Create a S3 Bucket for Lambda Code
module "s3" {
  source     = "github.com/nclouds/terraform-aws-s3-bucket?ref=v0.2.6"
  identifier = var.identifier
}

# Upload Lambda Code to S3 Bucket
module "file" {
  source      = "github.com/nclouds/terraform-aws-s3-bucket//modules/s3-object?ref=v0.2.6"
  file_source = "../utils/lambda_function_advanced.zip"
  bucket      = module.s3.output.bucket.id
  key         = "lambda_function_advanced.zip"
}

# Create IAM Policies
module "iam_policy_cw" {
  source          = "github.com/nclouds/terraform-aws-iam-policy?ref=v0.1.11"
  rendered_policy = data.aws_iam_policy_document.document_cw.json
  description     = "this policy allows access to cloudwatch logs"
  identifier      = "logs_admin_example_policy"
}

module "iam_policy_ec2" {
  source          = "github.com/nclouds/terraform-aws-iam-policy?ref=v0.1.11"
  rendered_policy = data.aws_iam_policy_document.document_ec2.json
  description     = "this policy allows access to ec2"
  identifier      = "ec2_admin_example_policy"
}

module "iam_policy_sqs" {
  source          = "github.com/nclouds/terraform-aws-iam-policy?ref=v0.1.11"
  rendered_policy = data.aws_iam_policy_document.document_sqs.json
  description     = "this policy allows access to sqs"
  identifier      = "sqs_admin_example_policy"
}

# Create an IAM Role for the Function
module "function_role" {
  source = "github.com/nclouds/terraform-aws-iam-role?ref=v1.0.2"
  iam_policies_to_attach = [
    module.iam_policy_cw.output.policy.arn,
    module.iam_policy_ec2.output.policy.arn,
    module.iam_policy_sqs.output.policy.arn
  ]
  trusted_service_arns = ["lambda.amazonaws.com"]
  identifier           = var.identifier
}

# Create a SQS Queue
module "queue" {
  source                      = "git@github.com:nclouds/terraform-aws-sqs.git?ref=v0.2.3"
  content_based_deduplication = true
  dead_letter_queue           = true
  fifo_queue                  = true
  identifier                  = var.identifier
}

# Create a Lambda Security Group
module "lambda_security_group" {
  source     = "github.com/nclouds/terraform-aws-security-group?ref=v0.2.9"
  identifier = "${var.identifier}-lambda-sg"
  vpc_id     = module.vpc.output.vpc.id
}

# Create a Lambda Layer
resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = "../utils/requests_lambda_layer.zip"
  layer_name = "python_requests"

  compatible_runtimes = ["python3.7"]
}

# Create the Function
module "function" {
  source                = "../.."
  identifier            = "example-function"
  iam_role              = module.function_role.output.role.arn
  handler               = "lambda_function.lambda_handler"
  runtime               = "python3.7"
  s3_bucket             = module.s3.output.bucket.id
  s3_key                = module.file.output.object.key
  source_code_hash      = module.file.output.object.etag
  layers                = [aws_lambda_layer_version.lambda_layer.arn]
  event_source_arn      = module.queue.output.queue.arn
  create_trigger        = true
  log_retention_in_days = 30
  memory_size           = 256
  timeout               = 30
  security_group_ids    = [module.lambda_security_group.output.security_group.id]
  subnet_ids            = module.vpc.output.public_subnets.*.id
}
