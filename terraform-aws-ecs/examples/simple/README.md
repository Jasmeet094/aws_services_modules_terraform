[SourceCode](https://github.com/nclouds/terraform-aws-ecs/tree/master/examples/simple)   
[Report an Issue](https://github.com/nclouds/terraform-aws-ecs/issues)

# Simple ECS example

Configuration in this directory creates the following ECS Resources with Default configuration.
- ECS Cluster
- ECS Task Definitions
- ECS Service
- Application Load Balancer

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.
