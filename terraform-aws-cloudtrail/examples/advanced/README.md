[SourceCode](https://github.com/nclouds/terraform-aws-cloudtrail/tree/master/examples/advanced)   
[Report an Issue](https://github.com/nclouds/terraform-aws-cloudtrail/issues)

# Simple CloudTrail example

Configuration in this directory creates the following Resources:
- A S3 bucket with a Bucket Policy to allow CloudTrail log events.
- A SNS Topic where the CloudTrail is delievered to.
- SNS Topic Policy
- Cloudwatch Log Group where the Trail is delivered to.
- IAM Role witha  custom IAM Policy for Cloudwatch Log Delivery
- AWS ClouTrail

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.
