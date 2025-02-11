<p align="left"><img width=400 height="100" src="https://www.nclouds.com/img/nclouds-logo.svg"></p>  

![Terraform](https://github.com/nclouds/terraform-aws-efs/workflows/Terraform/badge.svg)
# nCode Library

## AWS Elastic File System (EFS) Terraform Module

Terraform module to provision [`Elastic File System`](https://aws.amazon.com/efs) on AWS.

## Usage

### Simple setup

Create a simple EFS with default configurations.
```hcl
    module "efs" {
        source                  = "git@github.com:nclouds/terraform-aws-efs.git?ref=v0.1.10"
        identifier              = "example"
        encrypted               = false
        tags                    = {
            Owner = "sysops"
            env   = "dev"
        }
        subnet_ids              = [
            "subnet-xxxxxx"
        ]
        security_groups         = [
            "sg-xxxxxxxx"
        ]
    }
```

For more details on a working example, please visit [`examples/simple`](examples/simple)

### Advanced Setup
If you want to create EFS with enhanced configuration e.g Enable Encryption, Multiple AZs etc., you can use the module like this:

```hcl
    module "efs" {
        source                          = "git@github.com:nclouds/terraform-aws-efs.git?ref=v0.1.10"
        identifier                      = "example"
        encrypted                       = true
        performance_mode                = "maxIO"
        throughput_mode                 = "provisioned"
        provisioned_throughput_in_mibps = "1"
        tags = {
            Owner = "sysops"
            env   = "dev"
        }
        subnet_ids = [
            "subnet-xxxxxxxxxxxxx", 
            "subnet-xxxxxxxxxxxxx"
        ]
        security_groups = [
            "sg-xxxxxxxxxxx"
        ]
    }
```

For more options refer to a working example at [`examples/advanced`](examples/advanced)

## Examples
Here are some working examples of using this module:
- [`examples/simple`](examples/simple)
- [`examples/advanced`](examples/advanced)


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
| [aws_efs_file_system.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_append_workspace"></a> [append\_workspace](#input\_append\_workspace) | Appends the terraform workspace at the end of resource names, <identifier>-<worspace> | `bool` | `true` | no |
| <a name="input_encrypted"></a> [encrypted](#input\_encrypted) | If true, the disk will be encrypted | `bool` | `true` | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | A name for all resources | `string` | n/a | yes |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The ARN for the KMS encryption key. When specifying kms\_key\_id, encrypted needs to be set to true | `string` | `null` | no |
| <a name="input_performance_mode"></a> [performance\_mode](#input\_performance\_mode) | The file system performance mode | `string` | `"generalPurpose"` | no |
| <a name="input_provisioned_throughput_in_mibps"></a> [provisioned\_throughput\_in\_mibps](#input\_provisioned\_throughput\_in\_mibps) | The throughput, measured in MiB/s, that you want to provision for the file system. Only applicable with throughput\_mode set to provisioned | `string` | `null` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | List of security groups to assign to all the EFS mount points | `list(string)` | `[]` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnets ids to deploy EFS mount points in | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the resource | `map(any)` | `{}` | no |
| <a name="input_throughput_mode"></a> [throughput\_mode](#input\_throughput\_mode) | Throughput mode for the file system | `string` | `"bursting"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_output"></a> [output](#output\_output) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contributing
If you want to contribute to this repository check all the guidelines specified [here](.github/CONTRIBUTING.md) before submitting a new PR.

## Authors

Module managed by [nClouds](https://github.com/nclouds).
