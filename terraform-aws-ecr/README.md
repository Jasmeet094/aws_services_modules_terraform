<p align="left"><img width=400 height="100" src="https://www.nclouds.com/img/nclouds-logo.svg"></p>  

![Terraform](https://github.com/nclouds/terraform-aws-ecr/workflows/Terraform/badge.svg)
# nCode Library

## AWS ECR terraform Module

Terraform module to provision an [`AWS ECR Docker Container registry`](https://aws.amazon.com/ecr/).

## Usage

### Miminal setup
If you want to create a ECR repository with Default configuration, use the module like this:

```hcl
module "ecr" {
  source      = "git@github.com:nclouds/terraform-aws-ecr.git?ref=v0.2.11"
  identifier  = "example"
}
```
For more details on a working minimal example, please visit [`examples/simple`](examples/simple)

### Advanced Setup
If you want to create a ECR repository with your custom configuration, you can provide some additional parameters:

```hcl
module "ecr" {
  source                  = "git@github.com:nclouds/terraform-aws-ecr.git?ref=v0.2.11"
  identifier              = "example"
  scan_on_push            = false
  image_tag_mutability    = "IMMUTABLE"
  tags = {
      Cost_Center = "XYZ"
  }
}
```
For more details on a complete working example, please visit [`examples/advanced`](examples/advanced)

## Examples
Here are some working examples of using this module:
- [`examples/simple`](examples/simple)
- [`examples/advanced`](examples/advanced)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15 |

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
| [aws_ecr_lifecycle_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.repo_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_append_workspace"></a> [append\_workspace](#input\_append\_workspace) | Appends the terraform workspace at the end of resource names, <identifier>-<worspace> | `bool` | `true` | no |
| <a name="input_ecr_allowed_access"></a> [ecr\_allowed\_access](#input\_ecr\_allowed\_access) | AWS Account IDs or user ARNs for cross account access | `list(string)` | `[]` | no |
| <a name="input_encryption_type"></a> [encryption\_type](#input\_encryption\_type) | The encryption type to use for the repository. Valid values are AES256 or KMS. Defaults to AES256 | `string` | `"KMS"` | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | (Required) Name of the repository | `string` | n/a | yes |
| <a name="input_image_tag_mutability"></a> [image\_tag\_mutability](#input\_image\_tag\_mutability) | (Optional) The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE. Defaults to MUTABLE | `string` | `"IMMUTABLE"` | no |
| <a name="input_kms_arn"></a> [kms\_arn](#input\_kms\_arn) | The ARN of the KMS key to use when encryption\_type is KMS. If not specified, uses the default AWS managed key for ECR. | `string` | `null` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | The lifecycle policy to delete images older than 14 days | `string` | `"{\n    \"rules\": [\n        {\n            \"rulePriority\": 1,\n            \"description\": \"Expire images older than 14 days\",\n            \"selection\": {\n                \"tagStatus\": \"untagged\",\n                \"countType\": \"sinceImagePushed\",\n                \"countUnit\": \"days\",\n                \"countNumber\": 14\n            },\n            \"action\": {\n                \"type\": \"expire\"\n            }\n        }\n    ]\n}\n"` | no |
| <a name="input_repo_policy"></a> [repo\_policy](#input\_repo\_policy) | The repo policy to allow access/control on the repo. Needs to be a fully formatted JSON policy and it overrides the 'ecr\_allowed\_access' variable. If blank a default policy is set in the locals | `string` | `""` | no |
| <a name="input_scan_on_push"></a> [scan\_on\_push](#input\_scan\_on\_push) | (Optional) Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false). Defaults to true | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to assign to the resource | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_output"></a> [output](#output\_output) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contributing
If you want to contribute to this repository check all the guidelines specified [here](.github/CONTRIBUTING.md) before submitting a new PR.
