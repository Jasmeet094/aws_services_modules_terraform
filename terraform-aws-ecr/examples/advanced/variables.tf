variable "tags" {
  description = "Tags for the resource"
  default = {
    Owner       = "sysops"
    env         = "dev"
    Cost_Center = "XYZ"
  }
  type = map(any)
}
