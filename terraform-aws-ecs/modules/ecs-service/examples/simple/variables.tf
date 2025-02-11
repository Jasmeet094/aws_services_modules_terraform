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

variable "lb_port" {
  description = "Port for incoming traffic to Load Balancer"
  type        = number
  default     = 8080
}
