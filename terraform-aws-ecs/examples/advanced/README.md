[SourceCode](https://github.com/nclouds/terraform-aws-ecs/tree/master/examples/advanced)   
[Report an Issue](https://github.com/nclouds/terraform-aws-ecs/issues)

# Advanced ECS example

Configuration in this directory creates the following ECS Resources with Default configuration.
- ECS Cluster
- ECS Task Definitions
- ECS Service
- Application Load Balancer
- IAM Role for Tasks
- Cloudwatch Log Group
- SSM Parameter Store Entry for Secrets

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.
