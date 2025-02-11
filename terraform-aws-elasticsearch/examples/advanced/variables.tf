# Multi-AZ Setup
variable "zone_awareness_enabled" {
  description = "Indicates whether zone awareness is enabled, set to true for multi-az deployment."
  default     = false
  type        = bool
}

# Subnets
variable "es_subnets_ids" {
  description = "List of VPC Subnet IDs for the Elasticsearch domain endpoints to be created in."
  type        = list(string)
  default     = ["subnet-xxxxxxxxxxxxx"]
}

variable "identifier" {
  description = "Name of the resources"
  default     = "example"
  type        = string
}
