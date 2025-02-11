# VPC
variable "create_vpc" {
  description = "Create a new VPC"
  default     = true
  type        = bool
}

variable "identifier" {
  description = "Name of the resources"
  default     = "example"
  type        = string
}

variable "tags" {
  description = "Tags for the resource"
  default = {
    Terraform   = true
    Environment = "dev"
    Name        = "Example"
    Owner       = "sysops"
    env         = "dev"
    Cost_Center = "XYZ"
  }
  type = map(any)
}

variable "append_workspace" {
  description = "Appends the terraform workspace at the end of resource names, <identifier>-<worspace>"
  default     = true
  type        = bool
}
