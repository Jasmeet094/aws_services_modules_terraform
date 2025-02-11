variable "vpc_settings" {
  description = "Map of AWS VPC settings"
  default = {
    application_subnets = ["172.20.16.0/22", "172.20.20.0/22"]
    public_subnets      = ["172.20.0.0/22", "172.20.4.0/22"]
    dns_hostnames       = true
    data_subnets        = ["172.20.8.0/22", "172.20.12.0/22"]
    dns_support         = true
    tenancy             = "default"
    cidr                = "172.20.0.0/16"
  }
  type = object({
    application_subnets = list(string)
    public_subnets      = list(string)
    data_subnets        = list(string)
    dns_hostnames       = bool,
    dns_support         = bool,
    tenancy             = string,
    cidr                = string
  })
}

variable "description" {
  description = "A description for the VPC"
  default     = "VPC created by terraform"
  type        = string
}

variable "identifier" {
  description = "Name of the VPC"
  type        = string
}

variable "region" {
  description = "Region where the VPC will be deployed"
  type        = string
}

variable "kubernetes_tagging" {
  description = "Set to true to enable kubernetes required tags for subnets"
  default     = false
  type        = bool
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map(any)
}

variable "multi_nat_gw" {
  description = "Set to true to create a nat gateway per availability zone, symmetrical subnets are required for best performance, try to avoid different subnet count between layers"
  default     = false
  type        = bool
}

variable "disable_nat_gw" {
  description = "Set to true to disable NATs deploy, false as default"
  default     = false
  type        = bool
}

variable "flow_log_settings" {
  description = "Map of VPC Flow Logs settings"
  default = {
    log_destination_type     = "s3"
    enable_flow_log          = true
    traffic_type             = "ALL",
    max_aggregation_interval = 600,
    iam_role_arn             = null,
    flow_log_destination_arn = null,
    logs_retention_in_days   = null,
  }
  type = object({
    log_destination_type     = string,
    enable_flow_log          = bool,
    traffic_type             = string,
    max_aggregation_interval = number,
    iam_role_arn             = string,
    flow_log_destination_arn = string,
    logs_retention_in_days   = number,
  })
}

variable "append_workspace" {
  description = "Appends the terraform workspace at the end of resource names, <identifier>-<worspace>"
  default     = true
  type        = bool
}

variable "create_private_endpoints" {
  description = "Set to true to create private endpoints"
  default     = true
  type        = bool
}

# TODO To be deprecated in a future release
variable "allowed_cidr_blocks_application" {
  description = "List of allowed CIDR blocks into application subnets via NACL, rule IDs are generated automatically. Only set this after the VPC has been created. (Use 'allowed_cidr_blocks_application_priority' variable instead."
  default     = []
  type        = list(string)
}

variable "allowed_cidr_blocks_application_priority" {
  description = "List of allowed CIDR blocks into application subnets via NACL, rule IDs have to be set manually per CIDR. Only set this after the VPC has been created"
  default     = []
  type = list(object({
    rule_id = number,
    cidr    = string
  }))
}

# TODO To be deprecated in a future release
variable "allowed_cidr_blocks_data" {
  description = "List of allowed CIDR blocks into data subnets via NACL, rule IDs are generated automatically. Only set this after the VPC has been created. (Use 'allowed_cidr_blocks_data_priority' variable instead.)"
  default     = []
  type        = list(string)
}

variable "allowed_cidr_blocks_data_priority" {
  description = "List of allowed CIDR blocks into application subnets via NACL, rule IDs have to be set manually per CIDR. Only set this after the VPC has been created"
  default     = []
  type = list(object({
    rule_id = number,
    cidr    = string
  }))
}