variable "istio_version" {
  description = "version of istio to use"
  type        = string
  default     = "1.9.4"
}

variable "istio_namespace" {
  description = "namespace to set and use"
  type        = string
  default     = "istio-system"
}

variable "istio_chart_values" {
  description = "Map of Helm values for the kubernetes-dashboard Helm chart. (Eg. {aws.region = \"us-west-2\"})"
  type        = map(string)
  default     = {}
}

variable "istio_yaml_values" {
  description = "List of Helm values in raw yaml for the kubernetes-dashboard Helm chart."
  type        = list(string)
  default     = []
}

variable "use_istio_ingress" {
  description = "Set true if the istio ingress chart should also be created"
  type        = bool
  default     = false
}

variable "use_istio_egress" {
  description = "Set true if the istio egress chart should also be created"
  type        = bool
  default     = false
}

