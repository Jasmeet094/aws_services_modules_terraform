# terraform-aws-ecs-service

Terraform module to create an [`ECS Service definition`](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs_services.html) on AWS.


## Usage

### Miminal setup
If you want to create an ECS Service Definition with Default configuration, use the module like this:

```hcl
    module ecs_service {
        source          = "git@github.com:nclouds/terraform-aws-ecs.git//modules/ecs-service?ref=v0.2.6"
        cluster         = "example-cluster-id"
        identifier      = "example"
        container_port  = 80
        vpc_id          = "vpc-xxxxxxxxxx"
        task_definition = "arn:aws:ecs:us-west-2:xxxxxxx:task-definition/TaskDefinitionFamily:1"
        listener_arn    = "arn:aws:elasticloadbalancing:us-west-1:xxxxxxxx:listener/app/my-load-balancer/xxxx"
        tags = {
            Cost_Center = "XYZ"
        }
    }
```
For more details on a working simple example, please visit [`examples/simple`](examples/simple)

### Advanced Setup
If you want to create an ECS Service Definition with your custom configuration, you can provide some additional parameters:

```hcl 
    module ecs_service {
        source                             = "git@github.com:nclouds/terraform-aws-ecs.git//modules/ecs-service?ref=v0.2.6"
        cluster                            = "example-cluster-id"
        identifier                         = "example"
        health_check_path                  = "/"
        path_pattern                       = ["/*"]
        scheduling_strategy                = "REPLICA"
        deployment_maximum_percent         = 100
        deployment_minimum_healthy_percent = 0
        container_port                     = 80
        vpc_id                             = "vpc-xxxxxxxxxx"
        task_definition                    = "arn:aws:ecs:us-west-2:xxxxxxx:task-definition/TaskDefinitionFamily:1"
        listener_arn                       = "arn:aws:elasticloadbalancing:us-west-1:xx:listener/app/my-load-balancer/xxxx"
        desired_count                      = 1
        tags = {
            Cost_Center = "XYZ"
        }
    }
```
For more details on an advanced working example, please visit [`examples/advanced`](examples/advanced)

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

## Resources

| Name | Type |
|------|------|
| [aws_ecs_service.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_append_workspace"></a> [append\_workspace](#input\_append\_workspace) | Appends the terraform workspace at the end of resource names, <identifier>-<worspace> | `bool` | `true` | no |
| <a name="input_assign_public_ip"></a> [assign\_public\_ip](#input\_assign\_public\_ip) | Assign a public IP address for the Fargate launch type only | `bool` | `false` | no |
| <a name="input_capacity_provider"></a> [capacity\_provider](#input\_capacity\_provider) | Name of the capacity provider to use | `string` | `""` | no |
| <a name="input_cluster"></a> [cluster](#input\_cluster) | ARN of an ECS cluster | `string` | n/a | yes |
| <a name="input_deployment_maximum_percent"></a> [deployment\_maximum\_percent](#input\_deployment\_maximum\_percent) | The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment | `number` | `200` | no |
| <a name="input_deployment_minimum_healthy_percent"></a> [deployment\_minimum\_healthy\_percent](#input\_deployment\_minimum\_healthy\_percent) | The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment | `number` | `50` | no |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | The number of instances of the task definition to place and keep running | `number` | `0` | no |
| <a name="input_enable_ecs_managed_tags"></a> [enable\_ecs\_managed\_tags](#input\_enable\_ecs\_managed\_tags) | Specifies whether to enable Amazon ECS managed tags for the tasks within the service | `bool` | `true` | no |
| <a name="input_enable_execute_command"></a> [enable\_execute\_command](#input\_enable\_execute\_command) | Specifies whether to enable Amazon ECS Exec for the tasks within the service | `bool` | `true` | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | The name for the cluster | `string` | n/a | yes |
| <a name="input_launch_type"></a> [launch\_type](#input\_launch\_type) | Launch type on which to run your service. The valid values are EC2, FARGATE, and EXTERNAL. | `string` | `"EC2"` | no |
| <a name="input_load_balancer_configurations"></a> [load\_balancer\_configurations](#input\_load\_balancer\_configurations) | List of load balancer configurations objects | <pre>list(object({<br>    target_group_arn = string<br>    container_name   = string<br>    container_port   = number<br>  }))</pre> | `[]` | no |
| <a name="input_ordered_placement_strategies"></a> [ordered\_placement\_strategies](#input\_ordered\_placement\_strategies) | list of placement strategies to apply to the service | <pre>list(object({<br>    type  = string<br>    field = string<br>  }))</pre> | <pre>[<br>  {<br>    "field": "attribute:ecs.availability-zone",<br>    "type": "spread"<br>  },<br>  {<br>    "field": "memory",<br>    "type": "binpack"<br>  }<br>]</pre> | no |
| <a name="input_propagate_tags"></a> [propagate\_tags](#input\_propagate\_tags) | Specifies whether to propagate the tags from the task definition or the service to the tasks | `string` | `"SERVICE"` | no |
| <a name="input_scheduling_strategy"></a> [scheduling\_strategy](#input\_scheduling\_strategy) | The scheduling strategy to use for the service. The valid values are REPLICA and DAEMON | `string` | `"REPLICA"` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | Security groups associated with the task or service | `list(string)` | `[]` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | list of subnets for ecs network configuration | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the resource | `map(any)` | `{}` | no |
| <a name="input_task_definition"></a> [task\_definition](#input\_task\_definition) | The family and revision (family:revision) or full ARN of the task definition that you want to run in your service | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_output"></a> [output](#output\_output) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contributing
If you want to contribute to this repository check all the guidelines specified [here](.github/CONTRIBUTING.md) before submitting a new PR.
