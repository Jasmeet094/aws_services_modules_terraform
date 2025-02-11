variable "identifier" {
  description = "Name of the resources"
  default     = "example"
  type        = string
}

variable "openvpn_password" {
  type        = string
  description = "Initial password for the openvpn user"
}
