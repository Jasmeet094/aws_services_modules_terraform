<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_backup_selection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| append\_workspace | Appends the terraform workspace at the end of resource names, <identifier>-<worspace> | `bool` | `true` | no |
| iam\_role\_arn | The ARN of the IAM role that AWS Backup uses to authenticate when restoring and backing up the target resource | `string` | n/a | yes |
| identifier | Identifier for all the resource | `string` | n/a | yes |
| plan\_id | The backup plan ID to be associated with the selection of resources | `string` | n/a | yes |
| resources | An array of strings that either contain Amazon Resource Names (ARNs) or match patterns of resources to assign to a backup plan | `list(string)` | `[]` | no |
| selection\_tags | Tag-based conditions used to specify a set of resources to assign to a backup plan | <pre>list(object({<br>    value = string<br>    type  = string<br>    key   = string<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| output | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->