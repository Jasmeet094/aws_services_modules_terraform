[SourceCode](https://github.com/nclouds/terraform-aws-vpc/tree/master/examples/simple)   
[Report an Issue](https://github.com/nclouds/terraform-aws-vpc/issues)

# Simple VPC example

Configuration in this directory creates the following VPC Resources with Default configuration.
- VPC
- Public Subnets
- Private Subnets (Application Subnets)
- Internet Gateway
- One NAT Gateway with Elastic IP
- Network ACLs for each subnets
- Route Tables and routes
- VPC Endpoints for ecr, ecs, s3, ssm

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.
