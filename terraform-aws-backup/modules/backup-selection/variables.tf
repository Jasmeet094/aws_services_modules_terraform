variable "identifier" {
  description = "Identifier for all the resource"
  type        = string
}

variable "plan_id" {
  description = "The backup plan ID to be associated with the selection of resources"
  type        = string
}

variable "iam_role_arn" {
  description = "The ARN of the IAM role that AWS Backup uses to authenticate when restoring and backing up the target resource"
  type        = string
}

variable "resources" {
  description = "An array of strings that either contain Amazon Resource Names (ARNs) or match patterns of resources to assign to a backup plan"
  default     = []
  type        = list(string)
}

variable "selection_tags" {
  description = "Tag-based conditions used to specify a set of resources to assign to a backup plan"
  default     = []
  type = list(object({
    value = string
    type  = string
    key   = string
  }))
}

variable "append_workspace" {
  description = "Appends the terraform workspace at the end of resource names, <identifier>-<worspace>"
  default     = true
  type        = bool
}
