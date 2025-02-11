<p align="left"><img width=400 height="100" src="https://www.nclouds.com/img/nclouds-logo.svg"></p>  

![Terraform](https://github.com/nclouds/terraform-aws-openvpn/workflows/Terraform/badge.svg)
# nCode Library

## OpenVPN terraform module

A terraform module to build an OpenVPN AS server with RDS as a backend for storing configurations. RDS support (enabled by default) can be disabled by setting `use_rds` variable to false if needed. In order to restore the settings from an RDS backup you can pass `snapshot_identifier` with the name of the backup identifier.

The openvpn instance is created using an autoscaling group of 1 instance; this makes it redundant and in the case of the instance failing for any reason, another one will be created and if using the RDS backend (default) it will keep the same configuration and settings. At boot time the instance is also attaching an EIP the module creates.

For cross-region redundancy the setup can use RDS replicas to setup a fully redundant setup or in the case of a cold setup it can use the RDS snapshot to create a new RDS instance if needed in a different region.

## Basic Module usage

To use the default mode (RDS backend) and default vault settings you would only have to invoke it like:

```hcl
module "openvpn" {
  source           = "git@github.com:nclouds/terraform-aws-openvpn.git?ref=v0.1.4"
  domain_name      = "vpn.domain.com"
  vpc_id           = "vpc-xxxxxxx"
  openvpn_password = "xxxxxxxxxx"
}
```

## Use a RDS snapshot backup

For redundancy reasons, if the RDS instance is to be recreated we can use a previous RDS snapshot to restore all the openvpn database (users, settings, etc.) by passing the `snapshot_identifier` variable. This is disabled by default and without it the module will create a clean new install. The RDS snapshot can be an automated or final snapshot from an openvpn compatible RDS database.

```hcl
module "openvpn" {
  source              = "git@github.com:nclouds/terraform-aws-openvpn.git?ref=v0.1.8"
  domain_name         = "vpn.domain.com"
  vpc_id              = "vpc-xxxxxxx"
  environment         = "dev"
  openvpn_password    = "xxxxxxxxxx"
  snapshot_identifier = "openvpndb-demo-final-f633c15acdcee37a0f936cd08c8acb3a"
}
```

## Development/testing usage

For quick development and testing the module can be used without RDS like this:

```hcl
module "openvpn" {
  source           = "git@github.com:nclouds/terraform-aws-openvpn.git?ref=v0.1.8"
  domain_name      = "vpn.domain.com"
  vpc_id           = "vpc-xxxxxxx"
  environment      = "dev"
  openvpn_password = "xxxxxxxxxx"
  use_rds          = false
}
```

Note: if using the official OpenVPN marketplace AMI you will have to subscribe first in the account.  
Use the link (for BOY): https://aws.amazon.com/marketplace/pp/B00MI40CAE/
or (for 100 connected devices) https://aws.amazon.com/marketplace/pp/B01DE7Y902/

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_common_tags"></a> [common\_tags](#module\_common\_tags) | git@github.com:nclouds/terraform-aws-common-tags.git | v0.1.2 |
| <a name="module_openvpn-rds-sg"></a> [openvpn-rds-sg](#module\_openvpn-rds-sg) | github.com/nclouds/terraform-aws-security-group.git | v0.2.6 |
| <a name="module_openvpn-sg"></a> [openvpn-sg](#module\_openvpn-sg) | github.com/nclouds/terraform-aws-security-group.git | v0.2.6 |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.openvpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_group_tag.tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group_tag) | resource |
| [aws_db_subnet_group.db_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_eip.openvpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_instance_profile.openvpn_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.openvpn_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.openvpn_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.openvpn_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm_attach_clw_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm_attach_clw_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm_attach_ec2_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm_attach_ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_configuration.openvpn_launch_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration) | resource |
| [aws_rds_cluster.db_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_instance.db_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_security_group_rule.openvpn-rds-ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_ami.openvpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_iam_policy_document.openvpn_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.openvpn_ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.openvpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | The AMI to use for openvpn instance, optional. If undefined the official openvpn marketplace image will be used | `string` | `""` | no |
| <a name="input_append_workspace"></a> [append\_workspace](#input\_append\_workspace) | Appends the terraform workspace at the end of resource names, <identifier>-<worspace> | `bool` | `true` | no |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Specifies whether any database modifications are applied immediately, or during the next maintenance window. Default is false. | `bool` | `false` | no |
| <a name="input_db_instance_type"></a> [db\_instance\_type](#input\_db\_instance\_type) | The instance class to use for RDS | `string` | `"db.t2.medium"` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The dns name of your OpenVPN deployment | `any` | n/a | yes |
| <a name="input_ec2_instance_type"></a> [ec2\_instance\_type](#input\_ec2\_instance\_type) | EC2 instance type for Openvpn server | `string` | `"t2.medium"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | `"dev"` | no |
| <a name="input_hosted_zone_id"></a> [hosted\_zone\_id](#input\_hosted\_zone\_id) | The hosted zone id | `string` | `""` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | EC2 Key name used for ssh access on the OpenVPN instance | `string` | `""` | no |
| <a name="input_openvpn_dns"></a> [openvpn\_dns](#input\_openvpn\_dns) | Have VPN clients use these specific DNS servers | `list(string)` | <pre>[<br>  "10.0.0.20",<br>  "10.0.0.21"<br>]</pre> | no |
| <a name="input_openvpn_networks"></a> [openvpn\_networks](#input\_openvpn\_networks) | Private subnets to which all clients should be given access | `list(string)` | <pre>[<br>  "10.0.0.0/16",<br>  "192.168.0.0/24"<br>]</pre> | no |
| <a name="input_openvpn_password"></a> [openvpn\_password](#input\_openvpn\_password) | Initial password for the openvpn user | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | List of Private subnet IDs where RDS Instance will be created. | `list(string)` | `[]` | no |
| <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids) | List of Public subnet IDs where VPN Instance will be created. | `list(string)` | `[]` | no |
| <a name="input_rds_backup_retention_period"></a> [rds\_backup\_retention\_period](#input\_rds\_backup\_retention\_period) | The days to retain backups for | `string` | `"7"` | no |
| <a name="input_rds_master_name"></a> [rds\_master\_name](#input\_rds\_master\_name) | Username for the master DB user | `string` | `"root"` | no |
| <a name="input_rds_storage_encrypted"></a> [rds\_storage\_encrypted](#input\_rds\_storage\_encrypted) | Specifies whether the DB cluster is encrypted | `bool` | `true` | no |
| <a name="input_snapshot_identifier"></a> [snapshot\_identifier](#input\_snapshot\_identifier) | (Optional) Specifies whether or not to restore the RDS from a snapshot; use the snapshot name | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the resource | `map(any)` | `{}` | no |
| <a name="input_use_rds"></a> [use\_rds](#input\_use\_rds) | Controls if RDS is used for storing OpenVPN configurations; default enabled | `bool` | `true` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Id of the VPC where OpenVPN server will be deploy | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_adminurl"></a> [adminurl](#output\_adminurl) | Admin Access URL for the OpenVPNServer |
| <a name="output_openvpn_rds_security_group_id"></a> [openvpn\_rds\_security\_group\_id](#output\_openvpn\_rds\_security\_group\_id) | The ID of the openvpn RDS security group |
| <a name="output_openvpn_security_group_id"></a> [openvpn\_security\_group\_id](#output\_openvpn\_security\_group\_id) | The ID of the openvpn security group |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
