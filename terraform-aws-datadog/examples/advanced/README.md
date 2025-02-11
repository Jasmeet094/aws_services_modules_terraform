[SourceCode](https://github.com/nclouds/terraform-aws-datadog/tree/master/examples/advanced)   
[Report an Issue](https://github.com/nclouds/terraform-aws-datadog/issues)

# Advanced Datadog Monitors example

Configuration in this directory creates the Datadog monitors for the following resources with custom configurations:
-   EC2 
-   ELB

Custom Configurations created:
- Metrics to Query
- Custom tags to trigger alerts
- Custom Notification Templates

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
