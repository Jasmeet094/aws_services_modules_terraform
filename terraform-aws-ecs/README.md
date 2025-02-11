<p align="left"><img width="400" height="100" src="https://www.nclouds.com/img/nclouds-logo.svg"></p>  

![Terraform](https://github.com/nclouds/terraform-aws-ecs/workflows/Terraform/badge.svg)
# nCode Library

## AWS Elastic Container Services (ECS) Terraform Module

Terraform module to provision [`ECS Resources`](https://aws.amazon.com/ecs/) on AWS.

This module contains ECS Service and ECS Task Definition as sub-modules under [`modules`](modules) folder.
In order to create an ECS Service , you need to create ECS Cluster and ECS Task Definition first as describe below.

## Usage

### Simple setup
Create a simple ECS cluster:

```hcl
module "ecs" {
  source             = "git@github.com:nclouds/terraform-aws-ecs.git?ref=v0.2.12"
  identifier         = "example"
  container_insights = "disabled"
  tags = {
    Cost_Center = "XYZ"
  }
}
```

Create a simple ECS Task Definition:

```hcl
module ecs_task_definition {
  source          = "git@github.com:nclouds/terraform-aws-ecs.git//modules/ecs-task-definition?ref=v0.2.12"
  identifier      = "example"
  container_image = "nginx"
  port_mappings = [
    {
      containerPort = 80
      hostPort      = 0
      protocol      = "tcp"
    }
  ]
}
```

Create a simple ECS Service:

```hcl
  module ecs_service {
    source          = "git@github.com:nclouds/terraform-aws-ecs.git//modules/ecs-service?ref=v0.2.12"
    cluster         = module.ecs.output.cluster.id
    identifier      = "example"
    container_port  = 80
    vpc_id          = "vpc-xxxxxxxxxxx"
    task_definition = "arn:aws:ecs:us-west-2:xxxxxxx:task-definition/TaskDefinitionFamily:1"
    listener_arn    = "arn:aws:elasticloadbalancing:us-west-1:xxxxxxxx:listener/app/my-load-balancer/xxxx"
    tags = {
      Cost_Center = "XYZ"
    }
  }
```

Important Note: Please make sure identifier in `ecs_task_definition` and `ecs_service` are same.

For more details on a working example, please visit [`examples/simple`](examples/simple)

### Advanced Setup
If you want to create a ElasticSearch Domain with an advanced configuration like Multi-AZ, you can use the module like this:

Create an ECS Cluster:
```hcl
  module "ecs" {
    source             = "git@github.com:nclouds/terraform-aws-ecs.git?ref=v0.2.12"
    identifier         = "example"
    container_insights = "disabled"
    tags = {
      Cost_Center = "XYZ"
    }
  }
```

Create a Task Definition
```hcl
  module ecs_task_definition {
    source          = "git@github.com:nclouds/terraform-aws-ecs.git//modules/ecs-task-definition?ref=v0.2.12"
    identifier      = "example"
    container_image = "nginx"
    port_mappings = [
      {
        containerPort = 80
        hostPort      = 0
        protocol      = "tcp"
      }
    ]
    tags = {
      Cost_Center = "XYZ"
    }
    execution_role_arn           = "arn:aws:iam::xxxxxx"
    task_role_arn                = ""
    container_memory             = 256
    container_memory_reservation = 128
    container_cpu                = 10
    essential                    = true
    environment = [
      {
        "name" : "ENVIRONMENT",
        "value" : "PROD"
      }
    ]
    log_configuration = {

      "logDriver" : "awslogs",
      "options" : {
        "awslogs-group" : var.identifier,
        "awslogs-region" : "us-east-1",
        "awslogs-stream-prefix" : "ecs"
      }
    }
  }
```

Create an ECS Service
```hcl
  module ecs_service {
    source                             = "git@github.com:nclouds/terraform-aws-ecs.git//modules/ecs-service?ref=v0.2.12"
    cluster                            = module.ecs.output.cluster.id
    identifier                         = var.identifier
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

## Resources

| Name | Type |
|------|------|
| [aws_ecs_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.capacity_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_append_workspace"></a> [append\_workspace](#input\_append\_workspace) | Appends the terraform workspace at the end of resource names, <identifier>-<worspace> | `bool` | `true` | no |
| <a name="input_capacity_providers"></a> [capacity\_providers](#input\_capacity\_providers) | Capacity providers for ECS cluster | `list(string)` | `[]` | no |
| <a name="input_container_insights"></a> [container\_insights](#input\_container\_insights) | Enable container insights for the ecs cluster | `string` | `"enabled"` | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | The name for the cluster | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the resource | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_output"></a> [output](#output\_output) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contributing
If you want to contribute to this repository check all the guidelines specified [here](.github/CONTRIBUTING.md) before submitting a new PR.
