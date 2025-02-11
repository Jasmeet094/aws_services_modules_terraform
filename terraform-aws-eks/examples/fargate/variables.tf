variable "identifier" {
  description = "ID for all resources"
  default     = "example"
  type        = string
}

variable "profile_selectors" {
  description = "selectors by namespace"
  default = [
    {
      namespace = "example"
      labels    = {}
    }
  ]
  type = list(object({
    namespace = string
    labels    = map(any)
  }))
}
