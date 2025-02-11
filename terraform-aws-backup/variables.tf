variable "identifier" {
  description = "Identifier for all the resource"
  default     = ""
  type        = string
}

variable "kms_key_arn" {
  description = "The server-side encryption key that is used to protect your backups"
  default     = null
  type        = string
}

variable "backup_vault_policy" {
  description = "The backup vault access policy document in JSON format"
  default     = ""
  type        = string
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map(any)
}

variable "create_backup_policy" {
  description = "Specify whether to create a backup policy or not"
  type        = bool
  default     = false
}

variable "append_workspace" {
  description = "Appends the terraform workspace at the end of resource names, <identifier>-<worspace>"
  default     = true
  type        = bool
}
