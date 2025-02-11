<p align="left"><img width=400 height="100" src="https://www.nclouds.com/img/nclouds-logo.svg"></p>  

![Terraform](https://github.com/nclouds/terraform-aws-cloudtrail/workflows/Terraform/badge.svg)
# nCode Library

## AWS Cloud Trail Terraform Module

Terraform module to provision [`CloudTrail`](https://aws.amazon.com/cloudtrail/) on AWS.

## Usage

### Simple setup

Create a simple AWS CloudTrail with default log delivery to a S3 bucket.
```hcl
        source                       = "git@github.com:nclouds/terraform-aws-cloudtrail.git?ref=v0.1.12"
        aws_account_id               = 123456789
        cloudtrail_name              = "example-cloudtrail"
        cloudtrail_sns_topic_enabled = false
        cloudwatch_logs_enabled      = false
        region                       = "us-east-1"
        s3_bucket_name               = "example-s3-bucket"
        is_organization_trail        = false
        tags                         = {
            Owner       = "sysops"
            env         = "dev"
            Cost_Center = "XYZ"
        }
    }
```

For more details on a working example, please visit [`examples/simple`](examples/simple)

### Advanced Setup
If you want to enable enhanced options like log delivery to a SNS topic and Cloudwatch Log Group etc., you can use the module like this:

```hcl
    module "cloudtrail" {
        source                              = "git@github.com:nclouds/terraform-aws-cloudtrail.git?ref=v0.1.12"
        aws_account_id                      = 123456789
        cloudtrail_name                     = "example-cloudtrail"
        cloudtrail_sns_topic_enabled        = true
        cloudtrail_sns_topic_name           = "example-cloudtrail-sns-topic"
        cloudwatch_logs_enabled             = true
        cloudwatch_logs_group_name          = "example-cloudtrail-log-group"
        cloudwatch_logs_retention_in_days   = 3
        iam_role_name                       = "example-cloudtrail-CloudWatch-Delivery-Role"
        iam_role_policy_name                = "example-cloudtrail-CloudWatch-Delivery-Policy"
        key_deletion_window_in_days         = 7
        region                              = "us-east-1"
        s3_bucket_name                      = "example-s3-bucket"
        is_organization_trail               = false
        tags                                = {
            Owner       = "sysops"
            env         = "dev"
            Cost_Center = "XYZ"
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

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloudwatch_delivery_iam_policy"></a> [cloudwatch\_delivery\_iam\_policy](#module\_cloudwatch\_delivery\_iam\_policy) | github.com/nclouds/terraform-aws-iam-policy.git | v0.1.12 |
| <a name="module_cloudwatch_delivery_iam_role"></a> [cloudwatch\_delivery\_iam\_role](#module\_cloudwatch\_delivery\_iam\_role) | github.com/nclouds/terraform-aws-iam-role.git | v1.0.2 |
| <a name="module_common_tags"></a> [common\_tags](#module\_common\_tags) | github.com/nclouds/terraform-aws-common-tags | v0.1.2 |
| <a name="module_kms"></a> [kms](#module\_kms) | github.com/nclouds/terraform-aws-kms.git | v0.1.5 |
| <a name="module_log_group"></a> [log\_group](#module\_log\_group) | github.com/nclouds/terraform-aws-cloudwatch.git | v0.1.17 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudtrail.global](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail) | resource |
| [aws_sns_topic.cloudtrail-sns-topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.local-account-cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_iam_policy_document.cloudtrail-sns-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cloudtrail_key_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cloudwatch_delivery_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS Account ID number of the account. | `any` | n/a | yes |
| <a name="input_cloudtrail_name"></a> [cloudtrail\_name](#input\_cloudtrail\_name) | The name of the trail. | `string` | `"cloudtrail-multi-region"` | no |
| <a name="input_cloudtrail_sns_topic_enabled"></a> [cloudtrail\_sns\_topic\_enabled](#input\_cloudtrail\_sns\_topic\_enabled) | Specifies whether the trail is delivered to a SNS topic. | `bool` | `true` | no |
| <a name="input_cloudtrail_sns_topic_name"></a> [cloudtrail\_sns\_topic\_name](#input\_cloudtrail\_sns\_topic\_name) | The SNS topic linked to the CloudTrail | `string` | `"cloudtrail-multi-region-sns-topic"` | no |
| <a name="input_cloudwatch_logs_enabled"></a> [cloudwatch\_logs\_enabled](#input\_cloudwatch\_logs\_enabled) | Specifies whether the trail is delivered to CloudWatch Logs. | `bool` | `true` | no |
| <a name="input_cloudwatch_logs_group_name"></a> [cloudwatch\_logs\_group\_name](#input\_cloudwatch\_logs\_group\_name) | The name of CloudWatch Logs group to which CloudTrail events are delivered. | `string` | `"cloudtrail-multi-region"` | no |
| <a name="input_cloudwatch_logs_retention_in_days"></a> [cloudwatch\_logs\_retention\_in\_days](#input\_cloudwatch\_logs\_retention\_in\_days) | Number of days to retain logs for. CIS recommends 365 days.  Possible values are: 0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653. Set to 0 to keep logs indefinitely. | `number` | `365` | no |
| <a name="input_iam_role_name"></a> [iam\_role\_name](#input\_iam\_role\_name) | The name of the IAM Role to be used by CloudTrail to delivery logs to CloudWatch Logs group. | `string` | `"CloudTrail-CloudWatch-Delivery-Role"` | no |
| <a name="input_iam_role_policy_name"></a> [iam\_role\_policy\_name](#input\_iam\_role\_policy\_name) | The name of the IAM Role Policy to be used by CloudTrail to delivery logs to CloudWatch Logs group. | `string` | `"CloudTrail-CloudWatch-Delivery-Policy"` | no |
| <a name="input_is_organization_trail"></a> [is\_organization\_trail](#input\_is\_organization\_trail) | Specifies whether the trail is an AWS Organizations trail. Organization trails log events for the master account and all member accounts. Can only be created in the organization master account. | `bool` | `false` | no |
| <a name="input_key_deletion_window_in_days"></a> [key\_deletion\_window\_in\_days](#input\_key\_deletion\_window\_in\_days) | Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days. Defaults to 30 days. | `number` | `10` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS region in which CloudTrail is set up. | `any` | n/a | yes |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | The name of the S3 bucket which will store configuration snapshots. | `any` | n/a | yes |
| <a name="input_s3_key_prefix"></a> [s3\_key\_prefix](#input\_s3\_key\_prefix) | The prefix for the specified S3 bucket. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Specifies object tags key and value. This applies to all resources created by this module. | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_output"></a> [output](#output\_output) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contributing
If you want to contribute to this repository check all the guidelines specified [here](.github/CONTRIBUTING.md) before submitting a new PR.

## Authors

Module managed by [nClouds](https://github.com/nclouds).
