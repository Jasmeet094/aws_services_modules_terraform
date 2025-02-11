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
| [aws_backup_plan.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_append_workspace"></a> [append\_workspace](#input\_append\_workspace) | Appends the terraform workspace at the end of resource names, <identifier>-<worspace> | `bool` | `true` | no |
| <a name="input_delete_after"></a> [delete\_after](#input\_delete\_after) | Specifies the number of days after creation that a recovery point is deleted | `number` | `7` | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | Identifier for all the resource | `string` | n/a | yes |
| <a name="input_schedule"></a> [schedule](#input\_schedule) | A CRON expression specifying when AWS Backup initiates a backup job | `string` | `"cron(0 5 * * ? *)"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the resource | `map(any)` | `{}` | no |
| <a name="input_target_vault_name"></a> [target\_vault\_name](#input\_target\_vault\_name) | The name of a logical container where backups are stored | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_output"></a> [output](#output\_output) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->