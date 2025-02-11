variable "identifier" {
  description = "The name of the log group"
  default     = "test"
  type        = string
}

variable "retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653."
  default     = 30
  type        = number
}

variable "use_custom_kms_key" {
  description = "Set to 'true' if you are passing a custom KMS Key ARN"
  default     = false
  type        = bool
}

variable "kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data"
  default     = null
  type        = string
}

variable "append_workspace" {
  description = "Appends the terraform workspace at the end of resource names, <identifier>-<worspace>"
  default     = true
  type        = bool
}

variable "use_name_prefix" {
  description = "Allow terraform to append a unique string at the end of resource names"
  default     = true
  type        = bool
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map(any)
}
