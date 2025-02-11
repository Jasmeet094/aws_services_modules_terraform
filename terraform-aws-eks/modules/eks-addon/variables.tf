variable "resolve_conflicts" {
  description = "Define how to resolve parameter value conflicts when migrating an existing add-on to an Amazon EKS add-on or when applying version updates to the add-on"
  default     = "OVERWRITE"
  type        = string
}

variable "addon_version" {
  description = "The version of the EKS add-on"
  default     = null
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
}

variable "addon_name" {
  description = "Name of the EKS add-on"
  type        = string
}

variable "service_account_role_arn" {
  description = " The Amazon Resource Name (ARN) of an existing IAM role to bind to the add-on's service account"
  default     = null
  type        = string
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map(any)
}
