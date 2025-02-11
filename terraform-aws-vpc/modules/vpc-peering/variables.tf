variable "requester" {
  description = "VPC id of the requester vpc for peering"
  default     = ""
  type        = string
}

variable "accepter" {
  description = "VPC id of the accepter vpc for peering"
  default     = ""
  type        = string
}

variable "accepter_cidr" {
  description = "CIDR range of the accepter vpc for peering"
  default     = ""
  type        = string

}
variable "requester_cidr" {
  description = "CIDR range of the requester vpc for peering"
  default     = ""
  type        = string
}

variable "accepter_route_tables" {
  description = "List of Route tables to add the peering routes on the accepter side"
  default     = []
  type        = list(string)
}
variable "requester_route_tables" {
  description = "List of Route tables to add the peering routes on the requester side"
  default     = []
  type        = list(string)
}

variable "accepter_allow_remote_vpc_dns_resolution" {
  description = "Indicates whether a local VPC can resolve public DNS hostnames to private IP addresses when queried from instances in a peer VPC"
  default     = true
  type        = bool
}

variable "requester_allow_remote_vpc_dns_resolution" {
  description = "Indicates whether a local VPC can resolve public DNS hostnames to private IP addresses when queried from instances in a peer VPC"
  default     = true
  type        = bool
}

variable "identifier" {
  description = "Name of the VPC"
  default     = "identifier"
  type        = string
}

variable "region" {
  description = "Region where the VPC will be deployed"
  default     = "us-west-2"
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
