<p align="left"><img width=400 height="100" src="https://www.nclouds.com/img/nclouds-logo.svg"></p>  

![Terraform](https://github.com/nclouds/terraform-aws-backup/workflows/Terraform/badge.svg)
# nCode Library

## AWS backup Terraform Module

Terraform module to provision [`AWS Backup Resources`](https://aws.amazon.com/backup/).

## Usage

### Simple setup

Create a simple Backup Vault with default configurations.
```hcl
    module "backup_vault" {
        source               = "git@github.com:nclouds/terraform-aws-backup.git?ref=v0.2.7"
        identifier           = "example"
        create_backup_policy = true
        backup_vault_policy  = <<POLICY
        {
        "Version": "2012-10-17",
        "Id": "default",
        "Statement": [
            {
            "Sid": "default",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": [
                "backup:DescribeBackupVault",
                "backup:DeleteBackupVault",
                "backup:PutBackupVaultAccessPolicy",
                "backup:DeleteBackupVaultAccessPolicy",
                "backup:GetBackupVaultAccessPolicy",
                "backup:StartBackupJob",
                "backup:GetBackupVaultNotifications",
                "backup:PutBackupVaultNotifications"
            ],
            "Resource": "${module.backup_vault.output.vault.arn}"
            }
        ]
        }
        POLICY
        tags                 = {
            Owner       = "sysops"
            env         = "dev"
            Cost_Center = "XYZ"
        }
    }

```

For more details on a working example, please visit [`examples/simple`](examples/simple)

### Advanced Setup
If you want to create an advanced configuration with Backup Vault, plan and selection of resources, you can use the module like this:

```hcl
    module "backup_vault" {
        source               = "git@github.com:nclouds/terraform-aws-backup.git?ref=v0.2.7"
        identifier           = "example"
        create_backup_policy = true
        backup_vault_policy  = <<POLICY
        {
        "Version": "2012-10-17",
        "Id": "default",
        "Statement": [
            {
            "Sid": "default",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": [
                "backup:DescribeBackupVault",
                "backup:DeleteBackupVault",
                "backup:PutBackupVaultAccessPolicy",
                "backup:DeleteBackupVaultAccessPolicy",
                "backup:GetBackupVaultAccessPolicy",
                "backup:StartBackupJob",
                "backup:GetBackupVaultNotifications",
                "backup:PutBackupVaultNotifications"
            ],
            "Resource": "${module.backup_vault.output.vault.arn}"
            }
        ]
        }
        POLICY
        tags                 = {
            Owner       = "sysops"
            env         = "dev"
            Cost_Center = "XYZ"
        }
    }

    module "backup_plan" {
        source            = "git@github.com:nclouds/terraform-aws-backup.git//modules/backup-plan?ref=v0.2.2"
        identifier        = "example"
        target_vault_name = module.backup_vault.output.vault.id
        tags              = {
            Owner       = "sysops"
            env         = "dev"
            Cost_Center = "XYZ"
        }
    }

    module "backup_selection" {
        source       = "git@github.com:nclouds/terraform-aws-backup.git//modules/backup-selection?ref=v0.2.7"
        identifier   = "example"
        plan_id      = module.backup_plan.output.plan.id
        iam_role_arn = "arn:aws:iam::XXXXXXXXXXX:role/example-backup-role-default"
        resources    = []
        selection_tags = [{
            type  = "STRINGEQUALS"
            key   = "Name"
            value = "example"
            }
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
| [aws_backup_vault.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault) | resource |
| [aws_backup_vault_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_append_workspace"></a> [append\_workspace](#input\_append\_workspace) | Appends the terraform workspace at the end of resource names, <identifier>-<worspace> | `bool` | `true` | no |
| <a name="input_backup_vault_policy"></a> [backup\_vault\_policy](#input\_backup\_vault\_policy) | The backup vault access policy document in JSON format | `string` | `""` | no |
| <a name="input_create_backup_policy"></a> [create\_backup\_policy](#input\_create\_backup\_policy) | Specify whether to create a backup policy or not | `bool` | `false` | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | Identifier for all the resource | `string` | `""` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The server-side encryption key that is used to protect your backups | `string` | `null` | no |
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
