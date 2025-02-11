<p align="left"><img width="400" height="100" src="https://www.nclouds.com/img/nclouds-logo.svg"></p>  

![Terraform](https://github.com/nclouds/terraform-boilerplate/workflows/Terraform/badge.svg)
# nCode Library

# Usage

## Simple setup

Create simple KMS key 

```hcl
module "kms" {
  source = "github.com/nclouds/terraform-aws-kms?ref=v0.1.6"

  deletion_window = 10
  identifier      = "simple-example"
}
```

## Advanced setup

Create advanced KMS key 

```hcl
module "kms" {
  source = "github.com/nclouds/terraform-aws-kms?ref=v0.1.6"

  deletion_window = 10
  enable_alias    = true
  description     = "my testing kms key"
  identifier      = "advanced-example"
  tags            = {}
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_common_tags"></a> [common\_tags](#module\_common\_tags) | github.com/nclouds/terraform-aws-common-tags | v0.1.2 |

## Resources

| Name | Type |
|------|------|
| [aws_kms_alias.a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_append_workspace"></a> [append\_workspace](#input\_append\_workspace) | Appends the terraform workspace at the end of resource names, <identifier>-<worspace> | `bool` | `true` | no |
| <a name="input_deletion_window"></a> [deletion\_window](#input\_deletion\_window) | deletion window for KMS key | `number` | `30` | no |
| <a name="input_description"></a> [description](#input\_description) | description for KMS key | `string` | `null` | no |
| <a name="input_enable_alias"></a> [enable\_alias](#input\_enable\_alias) | if the KMS key should have an alias | `bool` | `false` | no |
| <a name="input_enable_key_rotation"></a> [enable\_key\_rotation](#input\_enable\_key\_rotation) | enable key rotation | `bool` | `true` | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | identifier for resources to create | `string` | n/a | yes |
| <a name="input_policy"></a> [policy](#input\_policy) | policy for kms key | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the resource | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_output"></a> [output](#output\_output) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contributing
If you want to contribute to this repository check all the guidelines specified [here](.github/CONTRIBUTING.md) before submitting a new PR.

## Authors

Module managed by [nClouds](https://github.com/nclouds).
