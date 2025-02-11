# AWS Relational Database Service Proxy Terraform Module

Terraform module to provision [`Relational Database Proxy Service`](https://aws.amazon.com/rds/proxy) on AWS.

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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_common_tags"></a> [common\_tags](#module\_common\_tags) | github.com/nclouds/terraform-aws-common-tags | v0.1.2 |

## Resources

| Name | Type |
|------|------|
| [aws_db_proxy.db_proxy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_proxy) | resource |
| [aws_db_proxy_default_target_group.default_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_proxy_default_target_group) | resource |
| [aws_db_proxy_target.target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_proxy_target) | resource |
| [aws_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.db_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.policy_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_append_workspace"></a> [append\_workspace](#input\_append\_workspace) | Appends the terraform workspace at the end of resource names, <identifier>-<worspace> | `bool` | `true` | no |
| <a name="input_connection_borrow_timeout"></a> [connection\_borrow\_timeout](#input\_connection\_borrow\_timeout) | connection\_borrow\_timeout | `number` | `120` | no |
| <a name="input_db_engine"></a> [db\_engine](#input\_db\_engine) | RDS engine, Supported engine are MYSQL and POSTGRES | `string` | `"MYSQL"` | no |
| <a name="input_db_instance_identifier"></a> [db\_instance\_identifier](#input\_db\_instance\_identifier) | Name of the RDS DB | `string` | `"example"` | no |
| <a name="input_db_proxy_identifier"></a> [db\_proxy\_identifier](#input\_db\_proxy\_identifier) | name of the RDS DB proxy resource | `string` | `"example"` | no |
| <a name="input_db_proxy_sg"></a> [db\_proxy\_sg](#input\_db\_proxy\_sg) | Security groups for the RDS DB Proxy | `list(string)` | n/a | yes |
| <a name="input_db_proxy_subnets"></a> [db\_proxy\_subnets](#input\_db\_proxy\_subnets) | Subnet for RDS DB proxy | `list(string)` | n/a | yes |
| <a name="input_db_secret_arn"></a> [db\_secret\_arn](#input\_db\_secret\_arn) | Secret ARN of RDS DB | `string` | `null` | no |
| <a name="input_debug_logging"></a> [debug\_logging](#input\_debug\_logging) | Logging for RDS proxy | `bool` | `false` | no |
| <a name="input_iam_auth"></a> [iam\_auth](#input\_iam\_auth) | Enable IAM based authentication or not | `string` | `"DISABLED"` | no |
| <a name="input_idle_client_timeout"></a> [idle\_client\_timeout](#input\_idle\_client\_timeout) | Ideal timeout for client | `number` | `1800` | no |
| <a name="input_init_query"></a> [init\_query](#input\_init\_query) | Add an initialization query, or modify the current one | `string` | `"SET x=1, y=2"` | no |
| <a name="input_max_connections_percent"></a> [max\_connections\_percent](#input\_max\_connections\_percent) | max\_connections\_percent | `number` | `100` | no |
| <a name="input_max_idle_connections_percent"></a> [max\_idle\_connections\_percent](#input\_max\_idle\_connections\_percent) | max\_idle\_connections\_percent | `number` | `50` | no |
| <a name="input_require_tls"></a> [require\_tls](#input\_require\_tls) | Require TLS | `bool` | `true` | no |
| <a name="input_session_pinning_filters"></a> [session\_pinning\_filters](#input\_session\_pinning\_filters) | Choose a session pinning filter | `list(string)` | <pre>[<br>  "EXCLUDE_VARIABLE_SETS"<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the resource | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_output"></a> [output](#output\_output) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->