variable "identifier" {
  description = "Name of the resources"
  default     = "alb-example"
  type        = string
}

variable "bucket_name" {
  description = "bucket name to store logs if its an empty string, creates a new bucket"
  default     = ""
  type        = string
}

variable "bucket_logs_prefix" {
  description = "prefix for alb logs only needed if access logs are enabled"
  default     = "example"
  type        = string
}
