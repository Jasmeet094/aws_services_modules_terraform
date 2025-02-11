<p align="left"><img width=400 height="100" src="https://www.nclouds.com/img/nclouds-logo.svg"></p>  

![Terraform](https://github.com/nclouds/terraform-aws-control-tower/workflows/Terraform/badge.svg)
# nCode Library

## AWS Control Tower Module

Terraform module to provision [`Control Tower`](https://aws.amazon.com/controltower/) on AWS.

## Usage

### Simple setup

Create a simple Control Tower setup with default configurations.

```hcl
    module "controlTower" {
        source      = "git@github.com:nclouds/terraform-aws-control-tower.git?ref=v0.1.3"
        email                      = "example@abc.com"
        name                       = "example"
        organizational_unit        = "staging"
        sso                        = {
            email       = "john.doe@abc.com"
            first_name  = "John"
            last_name   = "Doe"
        }
        tags                       = {
            Owner       = "sysops"
            env         = "dev"
            Cost_Center = "XYZ"
        }
    }
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.15 |
| controltower | ~> 1.0 |

## Providers

| Name | Version |
|------|---------|
| controltower | ~> 1.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [controltower_aws_account](https://registry.terraform.io/providers/idealo/controltower/1.0/docs/resources/aws_account) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| email | Email of the root account | `string` | n/a | yes |
| id | The ID of this resource | `string` | `""` | no |
| name | Name of the account | `string` | n/a | yes |
| organizational\_unit | Name of the Organizational Unit under which the account resides | `string` | n/a | yes |
| region | Region to provision in | `string` | `"us-east-1"` | no |
| sso | Assigned SSO user settings | <pre>object({<br>    email      = string<br>    first_name = string<br>    last_name  = string<br>  })</pre> | n/a | yes |
| tags | Key-value map of resource tags for the account | `map(any)` | `{}` | no |

## Outputs

No output.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contributing
If you want to contribute to this repository check all the guidelines specified [here](.github/CONTRIBUTING.md) before submitting a new PR.

## Authors

Module managed by [nClouds](https://github.com/nclouds).
