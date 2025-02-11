variable "identifier" {
  description = "Name for the resources"
  type        = string
}

variable "description" {
  description = "Description for the IAM role"
  default     = "Created by terraform"
  type        = string
}

variable "iam_policies_to_attach" {
  description = "List of ARNs of IAM policies to attach"
  default     = []
  type        = list(string)
}

variable "provider_urls" {
  description = "List of URLs of the OIDC Providers"
  default     = []
  type        = list(string)
}

variable "oidc_fully_qualified_subjects" {
  description = "The fully qualified OIDC subjects to be added to the role policy"
  default     = []
  type        = set(string)
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


variable "trusted_iam_arns" {
  description = "ARNs of AWS IAM Roles who can assume these roles"
  type        = list(string)
  default     = []
}

variable "trusted_service_arns" {
  description = "AWS Services that can assume these roles"
  type        = list(string)
  default     = ["ec2.amazonaws.com"]
}
