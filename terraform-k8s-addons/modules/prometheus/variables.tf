variable "chart_version" {
  description = "Version of the nginx_ingress_controller Helm chart to use"
  type        = string
  default     = "15.4.2"
}

variable "values" {
  description = "Configurations for metrics-server chart"
  default     = {}
  type        = map(any)
}

variable "namespace" {
  description = "Namespace to deploy the prometheus stack in"
  default     = "prometheus"
  type        = string
}

variable "create_namespace" {
  description = "Create the namespace if it doesn't exist"
  default     = true
  type        = bool
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map(any)
}