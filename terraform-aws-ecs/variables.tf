variable "identifier" {
  description = "The name for the cluster"
  type        = string
}

variable "container_insights" {
  description = "Enable container insights for the ecs cluster"
  default     = "enabled"
  type        = string
}

variable "capacity_providers" {
  description = "Capacity providers for ECS cluster"
  default     = []
  type        = list(string)
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
