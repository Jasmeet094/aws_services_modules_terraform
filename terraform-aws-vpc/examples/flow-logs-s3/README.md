[SourceCode](https://github.com/nclouds/terraform-aws-vpc/tree/master/examples/flow-logs-s3)   
[Report an Issue](https://github.com/nclouds/terraform-aws-vpc/issues)

# Enhanced VPC example

Configuration in this directory creates the following VPC Resources with Enhanced configuration (HIPPA compliant)
- VPC with enhanced settings
- Public Subnets
- Private Subnets (Application Subnets and Data Subnets)
- Internet Gateway
- Multiple NAT Gateways with Elastic IPs
- Network ACLs for each subnets
- Route Tables and routes
- VPC Endpoints for ecr, ecs, s3, ssm
- Flow Logs S3 bucket
- VPC Flow Logs

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.
