[SourceCode](https://github.com/nclouds/terraform-aws-ec2/tree/master/examples/advanced)   
[Report an Issue](https://github.com/nclouds/terraform-aws-ec2/issues)

# Simple ECS example

Configuration in this directory creates the following resources
- VPC
- IAM role for the Instance
- Security Group for the Instance
- EC2 Instance in a VPC
- KMS Key for Volume Encryption

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.
