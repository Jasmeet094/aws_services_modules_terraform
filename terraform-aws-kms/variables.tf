variable "identifier" {
  description = "identifier for resources to create"
  type        = string
}

variable "description" {
  description = "description for KMS key"
  default     = null
  type        = string
}

variable "policy" {
  description = "policy for kms key"
  default     = null
  type        = string
}

variable "deletion_window" {
  description = "deletion window for KMS key"
  default     = 30
  type        = number
}

variable "enable_alias" {
  description = "if the KMS key should have an alias"
  default     = false
  type        = bool
}

variable "enable_key_rotation" {
  description = "enable key rotation"
  default     = true
  type        = bool
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map(any)
}

variable "append_workspace" {
  description = "Appends the terraform workspace at the end of resource names, <identifier>-<worspace>"
  default     = true
  type        = bool
}
