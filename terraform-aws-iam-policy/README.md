<p align="left"><img width=400 height="100" src="https://www.nclouds.com/img/nclouds-logo.svg"></p>  

![Terraform](https://github.com/nclouds/terraform-aws-iam-policy/workflows/Terraform/badge.svg)
# nCode Library

## AWS Identity and Access Management Policy (IAM Policy) Terraform Module

Terraform module to provision [`IAM Policy`](https://aws.amazon.com/iam/) on AWS.

## Usage

### Setup

Create a IAM Policy.
```hcl
    module "iam_policy" {
        source          = "github.com/nclouds/terraform-aws-iam-policy?ref=v0.1.12"
        identifier      = "example-iam-policy"
        description     = "IAM Policy for Cloudwatch Logs Administrator"
        rendered_policy = {
            actions = [
                "logs:*"
            ],
            resources = [
                "*",
            ]
        }
    }
```

## Examples
Here are some working examples of using this module:
- [`examples/`](examples/)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.50.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.50.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_common_tags"></a> [common\_tags](#module\_common\_tags) | github.com/nclouds/terraform-aws-common-tags.git | v0.1.2 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_append_workspace"></a> [append\_workspace](#input\_append\_workspace) | Appends the terraform workspace at the end of resource names, <identifier>-<worspace> | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | Description for the IAM policy | `string` | `"Created by terraform"` | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | Name for the resources | `string` | n/a | yes |
| <a name="input_path"></a> [path](#input\_path) | Path level of the IAM policy | `string` | `"/"` | no |
| <a name="input_rendered_policy"></a> [rendered\_policy](#input\_rendered\_policy) | Rendered JSON with the policy to be used | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the resource | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_output"></a> [output](#output\_output) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contributing
If you want to contribute to this repository check all the guidelines specified [here](.github/CONTRIBUTING.md) before submitting a new PR.
