<p align="left"><img width=400 height="100" src="https://www.nclouds.com/img/nclouds-logo.svg"></p>  

![Terraform](https://github.com/nclouds/terraform-aws-elasticsearch/workflows/Terraform/badge.svg)
# nCode Library

## AWS ElasticSearch terraform Module

Terraform module to provision an [`Elasticsearch`](https://aws.amazon.com/elasticsearch-service/).

## Usage

### Simple setup
If you want to create a ElasticSearch Domain with simple configuration and endpoints in a single Aavailability Zone, use the module like this:

```hcl
module "elasticsearch" {
  source                   = "git@github.com:nclouds/terraform-aws-elasticsearch.git?ref=v0.1.9"
  identifier               = "dummy-es-domain"
  instance_type            = "c5.large.elasticsearch"
  elasticsearch_version    = "7.9"
  dedicated_master_enabled = false
  dedicated_master_type    = "m5.large.elasticsearch"
  ebs_enabled              = true
  subnets_ids              = ["subnet-xxxxxxxxxxx"]
}
```

For more details on a working example, please visit [`examples/simple`](examples/simple)

### Advanced Setup
If you want to create a ElasticSearch Domain with an advanced configuration like Multi-AZ, you can use the module like this:

```hcl
module "elasticsearch" {
  source                        = "git@github.com:nclouds/terraform-aws-elasticsearch.git?ref=v0.1.9"
  identifier                    = "dummy-es-domain"
  instance_type                 = "m5.large.elasticsearch"
  elasticsearch_version         = "7.9"
  dedicated_master_enabled      = true
  ebs_enabled                   = true
  subnets_ids                   = ["subnet-xxxxxxx", "subnet-xxxxxxx"] # Pass minimum two subnets for Multi-AZ
  automated_snapshot_start_hour = 23
  zone_awareness_enabled        = true  # Multi-AZ enabled
  dedicated_master_count        = 3
  dedicated_master_type         = "m5.large.elasticsearch"
  instance_count                = 2
  volume_size                   = 20
  volume_type                   = "gp2"
  iops                          = 0
  tags = {
    Owner = "sysops"
    env   = "dev"
  }
}
```

For more options refer to a working example at [`examples/advanced`](examples/advanced)

## Examples
Here are some working examples of using this module:
- [`examples/simple`](examples/simple)
- [`examples/advanced`](examples/advanced)

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
| <a name="module_kms"></a> [kms](#module\_kms) | github.com/nclouds/terraform-aws-kms.git | v0.1.5 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.es_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_resource_policy.elasticsearch-log-publishing-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_resource_policy) | resource |
| [aws_elasticsearch_domain.es_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain) | resource |
| [aws_iam_policy_document.elasticsearch-log-publishing-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_advanced_security"></a> [advanced\_security](#input\_advanced\_security) | enable advanced security options | `bool` | `true` | no |
| <a name="input_append_workspace"></a> [append\_workspace](#input\_append\_workspace) | Appends the terraform workspace at the end of resource names, <identifier>-<worspace> | `bool` | `true` | no |
| <a name="input_automated_snapshot_start_hour"></a> [automated\_snapshot\_start\_hour](#input\_automated\_snapshot\_start\_hour) | Hour during which the service takes an automated daily snapshot of the indices in the domain. | `number` | `0` | no |
| <a name="input_dedicated_master_count"></a> [dedicated\_master\_count](#input\_dedicated\_master\_count) | Number of dedicated master nodes in the cluster. | `number` | `1` | no |
| <a name="input_dedicated_master_enabled"></a> [dedicated\_master\_enabled](#input\_dedicated\_master\_enabled) | Indicates whether dedicated master nodes are enabled for the cluster. | `bool` | `false` | no |
| <a name="input_dedicated_master_type"></a> [dedicated\_master\_type](#input\_dedicated\_master\_type) | Instance type of the dedicated master nodes in the cluster. | `string` | `""` | no |
| <a name="input_ebs_enabled"></a> [ebs\_enabled](#input\_ebs\_enabled) | Whether EBS volumes are attached to data nodes in the domain. | `bool` | `true` | no |
| <a name="input_elasticsearch_version"></a> [elasticsearch\_version](#input\_elasticsearch\_version) | The version of Elasticsearch to use. | `string` | n/a | yes |
| <a name="input_encryption_at_rest"></a> [encryption\_at\_rest](#input\_encryption\_at\_rest) | enable encryption at rest | `bool` | `true` | no |
| <a name="input_encryption_in_transit"></a> [encryption\_in\_transit](#input\_encryption\_in\_transit) | Encryption in transit | `bool` | `true` | no |
| <a name="input_enforce_https"></a> [enforce\_https](#input\_enforce\_https) | Enforce https option | `bool` | `true` | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | A name identifier for the ElasticSearch domain. | `string` | `""` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | The number of data nodes (instances) to use in the Amazon ES domain | `number` | `1` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type of data nodes in the cluster. | `string` | `""` | no |
| <a name="input_internal_db"></a> [internal\_db](#input\_internal\_db) | enable internal user database for advanced security options | `bool` | `true` | no |
| <a name="input_iops"></a> [iops](#input\_iops) | The baseline input/output (I/O) performance of EBS volumes attached to data nodes | `number` | `0` | no |
| <a name="input_log_publish"></a> [log\_publish](#input\_log\_publish) | enable log publishing | `bool` | `true` | no |
| <a name="input_master_password"></a> [master\_password](#input\_master\_password) | master password for advanced security options | `string` | `null` | no |
| <a name="input_master_user"></a> [master\_user](#input\_master\_user) | master username for advanced security options | `string` | `"username"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group ids. | `list(string)` | `[]` | no |
| <a name="input_subnets_ids"></a> [subnets\_ids](#input\_subnets\_ids) | List of all the subnets | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the resource | `map(any)` | `{}` | no |
| <a name="input_tls_security_policy"></a> [tls\_security\_policy](#input\_tls\_security\_policy) | tls encryption security policy version | `string` | `"Policy-Min-TLS-1-2-2019-07"` | no |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | The size of EBS volumes attached to data nodes (in GB). | `number` | `20` | no |
| <a name="input_volume_type"></a> [volume\_type](#input\_volume\_type) | The type of EBS volumes attached to data nodes. | `string` | `"gp2"` | no |
| <a name="input_zone_awareness_enabled"></a> [zone\_awareness\_enabled](#input\_zone\_awareness\_enabled) | Configuration block containing zone awareness settings. Documented below. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_output"></a> [output](#output\_output) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contributing
If you want to contribute to this repository check all the guidelines specified [here](.github/CONTRIBUTING.md) before submitting a new PR.
