[SourceCode](https://github.com/nclouds/terraform-aws-route53-record/tree/master/examples/advanced)   
[Report an Issue](https://github.com/nclouds/terraform-aws-route53-record/issues)

# Advanced Route53 record example
Configuration in this directory creates the following Resources:
- Application Load Balancer
- Security Group for ALB
- Route53 Record with an alias to the load balancer


## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.
