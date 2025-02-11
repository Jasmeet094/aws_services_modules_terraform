[SourceCode](https://github.com/nclouds/terraform-aws-rds/tree/v0.4.2/examples/rds_proxy)   
[Report an Issue](https://github.com/nclouds/terraform-aws-rds/issues)

#  RDS proxy

Configuration in this directory creates the following Resources:
- RDS Instance
- Security Group for RDS Instance
- RDS proxy endpoint
- Security Group for RDS proxy

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.
