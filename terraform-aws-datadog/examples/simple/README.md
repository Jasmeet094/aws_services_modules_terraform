[SourceCode](https://github.com/nclouds/terraform-aws-datadog/tree/master/examples/simple)   
[Report an Issue](https://github.com/nclouds/terraform-aws-datadog/issues)

# Simple Datadog Monitors example

Configuration in this directory creates the Datadog monitors for the following resources:
-   LAMBDA
-   K8s
-   EC2 
-   ECS
-   RDS
-   ELB
-   ALB

## Usage

To run this example you need to export the following environment variables:
```bash
export DD_API_KEY="xxxxxxxxxxxxxxxxxxxxxxxx"
export DD_APP_KEY="xxxxxxxxxxxxxxxxxxxxxxxx"
```

and then execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

