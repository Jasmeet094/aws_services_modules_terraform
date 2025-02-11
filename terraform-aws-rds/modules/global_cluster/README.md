# AWS Relational Database Service (RDS Global Cluster) Terraform Module

Terraform module to provision [`Relational Database Service`](https://aws.amazon.com/rds/) on AWS.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_rds_global_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_global_cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_append_workspace"></a> [append\_workspace](#input\_append\_workspace) | Appends the terraform workspace at the end of resource names, <identifier>-<worspace> | `bool` | `true` | no |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | Name for an automatically created database on cluster creation. Forces new resource | `string` | `"default"` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | If the Global Cluster should have deletion protection enabled. | `string` | `false` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | Name of the database engine to be used for this DB cluster | `string` | n/a | yes |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Engine version of the Aurora global database. Upgrading the engine version will result in all cluster members being immediately updated | `string` | n/a | yes |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Enable to remove DB Cluster members from Global Cluster on destroy | `string` | `false` | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | The global cluster identifier | `string` | n/a | yes |
| <a name="input_source_db_cluster_identifier"></a> [source\_db\_cluster\_identifier](#input\_source\_db\_cluster\_identifier) | Amazon Resource Name (ARN) to use as the primary DB Cluster of the Global Cluster on creation | `string` | `null` | no |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | Specifies whether the DB cluster is encrypted. Forces new resource | `string` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_output"></a> [output](#output\_output) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->