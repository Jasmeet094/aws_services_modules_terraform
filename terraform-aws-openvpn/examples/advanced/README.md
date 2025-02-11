[SourceCode](https://github.com/nclouds/terraform-aws-openvpn/tree/master/examples/advanced)   
[Report an Issue](https://github.com/nclouds/terraform-aws-openvpn/issues)

# Simple OpenVPN example

Configuration in this directory creates the following Resources:
- IAM Instance Profile for OpenVPN Server with required permissions.
- Launch Configuration for OpenVPN Instances.
- Autoscaling Group
- Security Groups
- RDS Instance for OpenVPN Backend


## Usage

To run this example you need to export the following environment variables:
```bash
export TF_VAR_openvpn_password="xxxxxxxxxxxxxxxxxxxxxxxx"
```

and then execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.
