# terraform-aws-ecs-capacity-provider

Terraform module to create an [`ECS Capacity Provider`](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/cluster-capacity-providers.html) on AWS.


## Usage

### Miminal setup
If you want to create attach an ECS Capacity provider to an ECS cluster, use the module like this:

Create an ECS Capacity provider
```hcl
    module "capacity_provider" {
        source                 = "git@github.com:nclouds/terraform-aws-ecs.git//modules/ecs-capacity-provider?ref=v0.2.6"
        identifier             = "example"
        auto_scaling_group_arn = "arn:aws:autoscaling:us-east-1:xxxxxx:autoScalingGroup:xxxxxx:autoScalingGroupName/asg-name"
        tags                   = {
            Cost_Center = "XYZ"
        }
    }
```

Attach the Capacity Provider to an ECS Cluster by it's name
```hcl
    module "ecs" {
        source             = "git@github.com:nclouds/terraform-aws-ecs.git?ref=v0.2.6"
        identifier         = "example"
        tags               = {
            Cost_Center = "XYZ"
        }
        capacity_providers = ["example"]
        depends_on = [
            module.capacity_provider.aws_ecs_capacity_provider
        ]
    }
```

For more details on a working simple example, please visit [`examples/simple`](examples/simple)


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
| [aws_ecs_capacity_provider.worker_capacity_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_capacity_provider) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_append_workspace"></a> [append\_workspace](#input\_append\_workspace) | Appends the terraform workspace at the end of resource names, <identifier>-<worspace> | `bool` | `true` | no |
| <a name="input_auto_scaling_group_arn"></a> [auto\_scaling\_group\_arn](#input\_auto\_scaling\_group\_arn) | Associated auto scaling group arn | `string` | n/a | yes |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | The name for the resource | `string` | n/a | yes |
| <a name="input_managed_termination_protection"></a> [managed\_termination\_protection](#input\_managed\_termination\_protection) | Enables or disables container-aware termination of instances in the auto scaling group when scale-in happens | `string` | `"ENABLED"` | no |
| <a name="input_max_scale_step"></a> [max\_scale\_step](#input\_max\_scale\_step) | The maximum step adjustment size | `number` | `1000` | no |
| <a name="input_min_scale_step"></a> [min\_scale\_step](#input\_min\_scale\_step) | The minimum step adjustment size | `number` | `1` | no |
| <a name="input_scaling_status"></a> [scaling\_status](#input\_scaling\_status) | Whether auto scaling is managed by ECS. Valid values are ENABLED and DISABLED | `string` | `"ENABLED"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the resource | `map(any)` | `{}` | no |
| <a name="input_target_capacity"></a> [target\_capacity](#input\_target\_capacity) | The target utilization for the capacity provider. A number between 1 and 100. | `number` | `100` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_output"></a> [output](#output\_output) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contributing
If you want to contribute to this repository check all the guidelines specified [here](.github/CONTRIBUTING.md) before submitting a new PR.

## Authors
Module managed by [nClouds](https://github.com/nclouds).