[SourceCode](https://github.com/nclouds/terraform-aws-efs/tree/master/examples/advanced)   
[Report an Issue](https://github.com/nclouds/terraform-aws-efs/issues)

# Simple EFS example

Configuration in this directory creates the following EFS Resources with Default configuration.
- An Encyrpted EFS FileSystem (encrypted with Default AWS KMS Key)
    - Provisioner Throughput
    - maxIO Performance Mode
- An EFS mount in multiple AZ
- A Security group attached to EFS mount

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.
