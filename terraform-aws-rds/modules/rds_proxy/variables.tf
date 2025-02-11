variable "db_proxy_identifier" {
  description = "name of the RDS DB proxy resource"
  default     = "example"
  type        = string
}

variable "db_engine" {
  description = "RDS engine, Supported engine are MYSQL and POSTGRES"
  default     = "MYSQL"
  type        = string
}

variable "db_proxy_sg" {
  description = "Security groups for the RDS DB Proxy"
  type        = list(string)
}

variable "db_proxy_subnets" {
  description = "Subnet for RDS DB proxy"
  type        = list(string)
}

variable "db_secret_arn" {
  description = "Secret ARN of RDS DB"
  default     = null
  type        = string
}

variable "db_instance_identifier" {
  description = "Name of the RDS DB"
  default     = "example"
  type        = string
}

variable "debug_logging" {
  description = "Logging for RDS proxy"
  default     = false
  type        = bool
}

variable "idle_client_timeout" {
  description = "Ideal timeout for client"
  default     = 1800
  type        = number
}

variable "require_tls" {
  description = "Require TLS"
  default     = true
  type        = bool
}

variable "iam_auth" {
  description = "Enable IAM based authentication or not"
  default     = "DISABLED"
  type        = string
}

variable "append_workspace" {
  description = "Appends the terraform workspace at the end of resource names, <identifier>-<worspace>"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to be applied to the resource"
  type        = map(any)
  default     = {}
}

variable "session_pinning_filters" {
  description = "Choose a session pinning filter"
  type        = list(string)
  default     = ["EXCLUDE_VARIABLE_SETS"]
}

variable "init_query" {
  description = "Add an initialization query, or modify the current one"
  type        = string
  default     = "SET x=1, y=2"
}

variable "max_idle_connections_percent" {
  description = "max_idle_connections_percent"
  type        = number
  default     = 50
}


variable "connection_borrow_timeout" {
  description = "connection_borrow_timeout"
  type        = number
  default     = 120
}

variable "max_connections_percent" {
  description = "max_connections_percent"
  type        = number
  default     = 100
}