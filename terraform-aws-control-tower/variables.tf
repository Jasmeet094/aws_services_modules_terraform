variable "region" {
  description = "Region to provision in"
  type        = string
  default     = "us-east-1"
}

variable "email" {
  description = "Email of the root account"
  type        = string
}

variable "name" {
  description = "Name of the account"
  type        = string
}

variable "organizational_unit" {
  description = "Name of the Organizational Unit under which the account resides"
  type        = string
}

variable "sso" {
  description = "Assigned SSO user settings"
  type = object({
    email      = string
    first_name = string
    last_name  = string
  })
}

variable "id" {
  description = "The ID of this resource"
  default     = ""
  type        = string
}

variable "tags" {
  description = "Key-value map of resource tags for the account"
  type        = map(any)
  default     = {}
}