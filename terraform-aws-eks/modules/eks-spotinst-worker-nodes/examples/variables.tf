# VPC
variable "create_vpc" {
  description = "Create a new VPC"
  default     = true
  type        = bool
}

# EKS Version
variable "eks_version" {
  description = "Desired Kubernetes master version"
  default     = "1.21"
  type        = string
}

variable "identifier" {
  description = "ID for all resources"
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