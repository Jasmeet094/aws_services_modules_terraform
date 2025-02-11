[SourceCode](https://github.com/nclouds/terraform-aws-rds/tree/v0.4.2/examples/global_cluster)   
[Report an Issue](https://github.com/nclouds/terraform-aws-rds/issues)

# Advanced RDS example

Configuration in this directory creates the following Resources:
- RDS Global Cluster
- VPC
- Security Group for RDS Instance
- RDS Cluster as part of the global cluster

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.
