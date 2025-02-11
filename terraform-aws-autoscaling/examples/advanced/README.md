[SourceCode](https://github.com/nclouds/terraform-aws-autoscaling/tree/master/examples/advanced)   
[Report an Issue](https://github.com/nclouds/terraform-aws-autoscaling/issues)

# Advanced ASG example

Configuration in this directory creates the following Resources:
- An AutoScaling Group
- A Launch Configuration attached to Autoscaling Group
- IAM Instance Profile to be attached to underlying Instances.
- Security Group for Instance

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.
