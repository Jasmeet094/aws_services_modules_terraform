variable "identifier" {
  description = "Identifier for all resources"
  type        = string
}

variable "append_workspace" {
  description = "Appends the terraform workspace at the end of resource names, <identifier>-<worspace>"
  default     = true
  type        = bool
}

variable "server_certificate_arn" {
  description = "The ARN of the ACM server certificate"
  type        = string
}

variable "saml_provider_arn" {
  description = "The ARN of the IAM SAML identity provider"
  type        = string
}

variable "self_service_saml_provider_arn" {
  description = "The ARN of the IAM SAML identity provider for the self service portal"
  type        = string
}

variable "client_cidr_block" {
  description = "The IPv4 address range, in CIDR notation, from which to assign client IP addresses"
  default     = "10.254.0.0/22"
  type        = string
}

variable "logs_enabled" {
  description = "Enable vpn logs to CloudWatch"
  default     = true
  type        = bool
}

variable "network_association" {
  description = "The ID of the subnet to associate with the Client VPN endpoint"
  type        = string
}

variable "internet_access_enabled" {
  description = "Enable internet access route through the VPN"
  default     = true
  type        = bool
}

variable "vpn_routes" {
  description = "List of routes to add to the VPN"
  default     = {}
  type = map(object({
    destination_cidr_block : string
    description : string
  }))
}

variable "authorization_rules" {
  description = "Authorization rules for AWS Client VPN endpoints"
  default     = {}
  type = map(object({
    target_network_cidr : string
    access_group_id : string
    description : string
  }))
}

variable "security_group_ids" {
  description = "The IDs of one or more security groups to apply to the target network"
  default     = null
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC to associate with the Client VPN endpoint"
  default     = null
  type        = string
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map(any)
}