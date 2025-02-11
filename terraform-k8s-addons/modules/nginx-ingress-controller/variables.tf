variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "nginx_ingress_controller_chart_version" {
  description = "Version of the nginx_ingress_controller Helm chart to use"
  type        = string
  default     = "7.6.6"
}

variable "nginx_ingress_controller_values" {
  description = "Configurations for nginx ingress controller"
  default     = {}
  type        = map(any)
}

variable "cluster_oidc_issuer_url" {
  description = "EKS Cluster OIDC issuer URL"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map(any)
}