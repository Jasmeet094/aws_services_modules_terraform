[SourceCode](https://github.com/nclouds/terraform-aws-lambda/tree/master/examples/simple)   
[Report an Issue](https://github.com/nclouds/terraform-aws-lambda/issues)

# Simple Lambda example

Configuration in this directory creates the following Resources:
- S3 Bucket
- Uploads Lambda code to S3 bucket
- IAM Role and Attach Policy for Lambda
- Lambda Function

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.
