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
