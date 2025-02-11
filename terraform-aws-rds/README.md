<p align="left"><img width=400 height="100" src="https://www.nclouds.com/img/nclouds-logo.svg"></p>  

![Terraform](https://github.com/nclouds/terraform-aws-rds/workflows/Terraform/badge.svg)
# nCode Library

## AWS Relational Database Service (RDS) Terraform Module

Terraform module to provision [`Relational Database Service`](https://aws.amazon.com/rds/) on AWS.

## Usage

### Simple setup

Create a simple RDS with default configurations.
```hcl
    module "rds" {
        source                      = "git@github.com:nclouds/terraform-aws-rds.git?ref=v0.4.8"
        rds_parameter_group_family  = "postgres11"
        rds_engine_version          = "11.6"
        rds_instance_class          = "db.t2.small"
        security_groups             = ["sg-xxxxxxxxxxxxx"]
        identifier                  = "example"
        subnets                     = ["subnet-xxxxxxxxxxxx", "subnet-xxxxxxxxxxxx"]
        vpc_id                      = "vpc-xxxxxxxxxxx"
        engine                      = "postgres"
        tags                        = {
                    Owner           = "sysops"
                    env             = "dev"
                    Cost_Center     = "XYZ"
        }
    }
```

For more details on a working example, please visit [`examples/simple`](examples/simple)

### Advanced Setup
If you want to create RDS with enhanced configuration e.g mutli-az etc., you can use the module like this:

```hcl
    module "rds" {
        source                      = "git@github.com:nclouds/terraform-aws-rds.git?ref=v0.4.8"
        rds_parameter_group_family  = "postgres11"
        rds_engine_version          = "11.6"
        rds_instance_class          = "db.t2.small"
        rds_database_name           = "example_db"
        rds_master_username         = "example_root"
        multi_az                    = true
        rds_allocated_storage       = 30
        backup_retention_period     = 14
        storage_type                = "gp2"
        allow_major_version_upgrade = true
        auto_minor_version_upgrade  = true
        publicly_accessible         = false
        skip_final_snapshot         = true
        security_groups             = ["sg-xxxxxxxxxxxxx"]
        identifier                  = "example"
        subnets                     = ["subnet-xxxxxxxxxxxx", "subnet-xxxxxxxxxxx"]
        vpc_id                      = "vpc-000fe2b5ddba6bb64"
        engine                      = "postgres"
        tags                        = {
                        Owner       = "sysops"
                        env         = "dev"
                        Cost_Center = "XYZ"
        }
    }
```

For more options refer to a working example at [`examples/advanced`](examples/advanced)

### Create RDS Proxy

Create rds proxy with database

```hcl
    module "rds" {
        source                      = "git@github.com:nclouds/terraform-aws-rds.git?ref=v0.4.8"
        rds_parameter_group_family  = "postgres11"
        rds_engine_version          = "11.6"
        rds_instance_class          = "db.t2.small"
        security_groups             = ["sg-xxxxxxxxxxxxx"]
        identifier                  = "example"
        subnets                     = ["subnet-xxxxxxxxxxxx", "subnet-xxxxxxxxxxxx"]
        vpc_id                      = "vpc-xxxxxxxxxxx"
        engine                      = "postgres"
        tags                        = {
                    Owner           = "sysops"
                    env             = "dev"
                    Cost_Center     = "XYZ"
        }
    }

    module "rds_proxy" {
        source                      = "git@github.com:nclouds/terraform-aws-rds.git//modules/rds_proxy?ref=v0.4.8"
        db_instance_identifier      = "database"
        db_proxy_identifier         = "example"
        db_proxy_subnets            = ["subnet-xxxxx","subnet-xxxxxx"]
        db_secret_arn               = "arn:aws:secretsmanager:xxxxx:xxxxxxxxx:secret:xxxxx"
        db_proxy_sg                 = ["sg-xxxxx"]
        db_engine                   = "MYSQL"
    }
```

For more options refer to a working example at [`examples/rds_proxy`](examples/rds_proxy)

## Examples
Here are some working examples of using this module:
- [`examples/simple`](examples/simple)
- [`examples/advanced`](examples/advanced)
- [`examples/global_cluster`](examples/global_cluster)
- [`examples/global_cluster`](examples/rds_proxy)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_common_tags"></a> [common\_tags](#module\_common\_tags) | github.com/nclouds/terraform-aws-common-tags | v0.1.2 |
| <a name="module_kms"></a> [kms](#module\_kms) | github.com/nclouds/terraform-aws-kms.git | v0.1.5 |
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | github.com/nclouds/terraform-aws-security-group.git | v0.2.9 |

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_parameter_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_db_subnet_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_secretsmanager_secret.master_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_major_version_upgrade"></a> [allow\_major\_version\_upgrade](#input\_allow\_major\_version\_upgrade) | Indicates that major version upgrades are allowed | `bool` | `false` | no |
| <a name="input_append_workspace"></a> [append\_workspace](#input\_append\_workspace) | Appends the terraform workspace at the end of resource names, <identifier>-<worspace> | `bool` | `true` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window | `bool` | `true` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Backup retention period | `number` | `7` | no |
| <a name="input_cidr_blocks_ingress"></a> [cidr\_blocks\_ingress](#input\_cidr\_blocks\_ingress) | List of cidr blocks to allow ingress to RDS | `list(string)` | `[]` | no |
| <a name="input_encryption"></a> [encryption](#input\_encryption) | (Optional) Specifies whether the DB instance is encrypted. Note that if you are creating a cross-region read replica this field is ignored and you should instead declare kms\_key\_id with a valid ARN | `bool` | `true` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | Define the engine for the database | `string` | n/a | yes |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | The name for the resources | `string` | n/a | yes |
| <a name="input_license_model"></a> [license\_model](#input\_license\_model) | License model for this DB instance | `string` | `null` | no |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | Set to 'true' to deploy the rds instance as multi-az | `bool` | `true` | no |
| <a name="input_password"></a> [password](#input\_password) | RDS DB password. If not set, random password will be used and stored in SSM, not needed if the instance is being created from a snapshot | `string` | `null` | no |
| <a name="input_publicly_accessible"></a> [publicly\_accessible](#input\_publicly\_accessible) | Bool to control if instance is publicly accessible | `bool` | `false` | no |
| <a name="input_rds_allocated_storage"></a> [rds\_allocated\_storage](#input\_rds\_allocated\_storage) | Allocated storage | `number` | `21` | no |
| <a name="input_rds_database_name"></a> [rds\_database\_name](#input\_rds\_database\_name) | Name of the database, not needed if the instance is being created from a snapshot | `string` | `"default_database"` | no |
| <a name="input_rds_database_port"></a> [rds\_database\_port](#input\_rds\_database\_port) | port for database instance | `number` | `0` | no |
| <a name="input_rds_engine_version"></a> [rds\_engine\_version](#input\_rds\_engine\_version) | Engine version for the db | `string` | n/a | yes |
| <a name="input_rds_instance_class"></a> [rds\_instance\_class](#input\_rds\_instance\_class) | Instance class for the database | `string` | n/a | yes |
| <a name="input_rds_master_username"></a> [rds\_master\_username](#input\_rds\_master\_username) | Master username for the database, not needed if the instance is being created from a snapshot | `string` | `"root"` | no |
| <a name="input_rds_parameter_group_family"></a> [rds\_parameter\_group\_family](#input\_rds\_parameter\_group\_family) | Parameter group family for the instance | `string` | n/a | yes |
| <a name="input_rds_parameters"></a> [rds\_parameters](#input\_rds\_parameters) | selectors by namespace | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | List of existing security groups for DB instance | `list(string)` | `[]` | no |
| <a name="input_security_groups_ingress"></a> [security\_groups\_ingress](#input\_security\_groups\_ingress) | List of security groups to allow ingress traffic to RDS | `list(string)` | `[]` | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Determines whether a final DB snapshot is created before the DB instance is deleted | `bool` | `true` | no |
| <a name="input_snapshot_identifier"></a> [snapshot\_identifier](#input\_snapshot\_identifier) | Specifies whether or not to create this database from a snapshot. This correlates to the snapshot ID. | `string` | `""` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Storage type for the db | `string` | `"gp2"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | A list of VPC subnet IDs | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the resource | `map(any)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC id for the resources | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_output"></a> [output](#output\_output) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contributing
If you want to contribute to this repository check all the guidelines specified [here](.github/CONTRIBUTING.md) before submitting a new PR.
