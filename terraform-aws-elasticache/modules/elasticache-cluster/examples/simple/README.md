[SourceCode](https://github.com/nclouds/terraform-aws-elasticache/tree/master/modules/elasticache-cluster/examples/simple)   
[Report an Issue](https://github.com/nclouds/terraform-aws-elasticache/issues)

# Simple ElastiCache example

Configuration in this directory creates an ElastiCache Cluster (redis) with a simple configuration in a single availability zone.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.
