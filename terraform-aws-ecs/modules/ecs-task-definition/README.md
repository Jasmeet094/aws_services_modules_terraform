# terraform-aws-ecs-task-definition

Terraform module to create an [`ECS task definition`](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definitions.html) on AWS.


## Usage

### Miminal setup
If you want to create an ECS Task Definition with Default configuration, use the module like this:

```hcl
    module ecs_task_definition {
        source          = "git@github.com:nclouds/terraform-aws-ecs.git//modules/ecs-task-definition?ref=v0.2.6"
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
    }
```
For more details on a working simple example, please visit [`examples/simple`](examples/simple)

### Advanced Setup
If you want to create an ECS Task Definition with your custom configuration, you can provide some additional parameters:

```hcl
    module ecs_task_definition {
        source          = "git@github.com:nclouds/terraform-aws-ecs.git//modules/ecs-task-definition?ref=v0.2.6"
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
            "awslogs-group" : "example",
            "awslogs-region" : "us-east-1",
            "awslogs-stream-prefix" : "ecs"
            }
        }
    }
```
For more details on an advanced working example, please visit [`examples/advanced`](examples/advanced)

## Examples
Here are some working examples of using this module:
- [`examples/simple`](examples/simple)
- [`examples/advanced`](examples/advanced)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
