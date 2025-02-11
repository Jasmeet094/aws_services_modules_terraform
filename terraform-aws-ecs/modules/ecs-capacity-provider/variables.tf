variable "identifier" {
  description = "The name for the resource"
  type        = string
}

variable "max_scale_step" {
  description = "The maximum step adjustment size"
  default     = 1000
  type        = number
}

variable "min_scale_step" {
  description = "The minimum step adjustment size"
  default     = 1
  type        = number
}

variable "scaling_status" {
  description = "Whether auto scaling is managed by ECS. Valid values are ENABLED and DISABLED"
  default     = "ENABLED"
  type        = string
}

variable "target_capacity" {
  description = "The target utilization for the capacity provider. A number between 1 and 100."
  default     = 100
  type        = number
}

variable "auto_scaling_group_arn" {
  description = "Associated auto scaling group arn"
  type        = string
}

variable "managed_termination_protection" {
  description = "Enables or disables container-aware termination of instances in the auto scaling group when scale-in happens"
  default     = "ENABLED"
  type        = string
}

variable "append_workspace" {
  description = "Appends the terraform workspace at the end of resource names, <identifier>-<worspace>"
  default     = true
  type        = bool
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map(any)
}
