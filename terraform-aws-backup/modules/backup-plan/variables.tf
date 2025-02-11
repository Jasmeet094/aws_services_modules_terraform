variable "identifier" {
  description = "Identifier for all the resource"
  type        = string
}

variable "target_vault_name" {
  description = "The name of a logical container where backups are stored"
  type        = string
}

variable "schedule" {
  description = "A CRON expression specifying when AWS Backup initiates a backup job"
  default     = "cron(0 5 * * ? *)"
  type        = string
}

variable "delete_after" {
  description = "Specifies the number of days after creation that a recovery point is deleted"
  default     = 7
  type        = number
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
