variable "lb_is_internal" {
  description = "Boolean that represent if the load balancer will be internal or no"
  default     = false
  type        = bool
}

variable "vpc_id" {
  description = "The VPC where all the resources belong"
  default     = ""
  type        = string
}

variable "alb_access_logs_enable" {
  description = "option to enable access logs, set to true to active it."
  default     = false
  type        = bool
}

variable "bucket_name" {
  description = "bucket name to store logs if its an empty string, creates a new bucket"
  default     = ""
  type        = string
}

variable "bucket_logs_prefix" {
  description = "prefix for alb logs only needed if access logs are enabled"
  default     = ""
  type        = string
}

variable "athena_integration" {
  description = "athena integration to query alb access logs. only available if access logs are enabled"
  default     = false
  type        = bool
}

variable "drop_invalid_header_fields" {
  description = "Drop invalid header on http requests"
  default     = true
  type        = bool
}

variable "security_groups" {
  description = "Security group"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of all the subnets"
  default     = []
  type        = list(string)
}

variable "alb_certificate_arn" {
  description = "ARN for the load balancer certificate"
  default     = []
  type        = list(string)
}

variable "identifier" {
  description = "Identifier for all the resource"
  default     = ""
  type        = string
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

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error"
  default     = false
  type        = bool
}
