variable "identifier" {
  description = "The name for the cluster"
  type        = string
}

variable "cluster" {
  description = "ARN of an ECS cluster"
  type        = string
}

variable "task_definition" {
  description = "The family and revision (family:revision) or full ARN of the task definition that you want to run in your service"
  type        = string
}

variable "launch_type" {
  description = "Launch type on which to run your service. The valid values are EC2, FARGATE, and EXTERNAL."
  type        = string
  default     = "EC2"
}

variable "desired_count" {
  description = "The number of instances of the task definition to place and keep running"
  default     = 0
  type        = number
}

variable "scheduling_strategy" {
  description = "The scheduling strategy to use for the service. The valid values are REPLICA and DAEMON"
  default     = "REPLICA"
  type        = string
}

variable "deployment_maximum_percent" {
  description = "The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment"
  default     = 200
  type        = number
}

variable "deployment_minimum_healthy_percent" {
  description = "The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment"
  default     = 50
  type        = number
}

variable "load_balancer_configurations" {
  description = "List of load balancer configurations objects"
  default     = []
  type = list(object({
    target_group_arn = string
    container_name   = string
    container_port   = number
  }))
}

variable "enable_ecs_managed_tags" {
  description = "Specifies whether to enable Amazon ECS managed tags for the tasks within the service"
  default     = true
  type        = bool
}

variable "enable_execute_command" {
  description = "Specifies whether to enable Amazon ECS Exec for the tasks within the service"
  default     = true
  type        = bool
}

variable "propagate_tags" {
  description = "Specifies whether to propagate the tags from the task definition or the service to the tasks"
  default     = "SERVICE"
  type        = string
}

variable "capacity_provider" {
  description = "Name of the capacity provider to use"
  default     = ""
  type        = string
}

variable "append_workspace" {
  description = "Appends the terraform workspace at the end of resource names, <identifier>-<worspace>"
  default     = true
  type        = bool
}

variable "ordered_placement_strategies" {
  description = "list of placement strategies to apply to the service"
  default = [
    {
      type  = "spread"
      field = "attribute:ecs.availability-zone"
    },
    {
      type  = "binpack"
      field = "memory"
    }
  ]
  type = list(object({
    type  = string
    field = string
  }))
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map(any)
}

variable "subnets" {
  description = "list of subnets for ecs network configuration"
  default     = []
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Assign a public IP address for the Fargate launch type only"
  default     = false
  type        = bool
}

variable "security_groups" {
  description = "Security groups associated with the task or service"
  default     = []
  type        = list(string)
}
