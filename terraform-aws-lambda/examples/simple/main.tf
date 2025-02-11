# Create a S3 Bucket for Lambda Code
module "s3" {
  source     = "github.com/nclouds/terraform-aws-s3-bucket?ref=v0.2.6"
  identifier = var.identifier
}

# Upload Lambda Code to S3 Bucket
module "file" {
  source      = "github.com/nclouds/terraform-aws-s3-bucket//modules/s3-object?ref=v0.2.6"
  file_source = "../utils/lambda_function.zip"
  bucket      = module.s3.output.bucket.id
  key         = "lambda_function.zip"
}

# Create an IAM Policy
module "iam_policy" {
  source          = "github.com/nclouds/terraform-aws-iam-policy?ref=v0.1.11"
  rendered_policy = data.aws_iam_policy_document.document.json
  description     = "this policy allows access to cloudwatch logs"
  identifier      = "logs_admin_example_policy"
}

# Create an IAM Role for the Function
module "function_role" {
  source                 = "github.com/nclouds/terraform-aws-iam-role?ref=v1.0.2"
  iam_policies_to_attach = [module.iam_policy.output.policy.arn]
  trusted_service_arns   = ["lambda.amazonaws.com"]
  identifier             = var.identifier
}

# Create the Function
module "function" {
  source           = "../.."
  identifier       = "example-function"
  iam_role         = module.function_role.output.role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.7"
  s3_bucket        = module.s3.output.bucket.id
  s3_key           = module.file.output.object.key
  source_code_hash = module.file.output.object.etag
}