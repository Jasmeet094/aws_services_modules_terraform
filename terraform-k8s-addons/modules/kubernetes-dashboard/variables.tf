variable "kubernetes_dashboard_chart_version" {
  description = "Version of the kubernetes-dashboard Helm chart to use"
  type        = string
  default     = "4.0.3"
}

variable "kubernetes_dashboard_namespace" {
  description = "Kubernetes namespace to deploy the kubernetes-dashboard controller"
  type        = string
  default     = "kubernetes-dashboard"
}

variable "kubernetes_dashboard_chart_values" {
  description = "Map of Helm values for the kubernetes-dashboard Helm chart. (Eg. {aws.region = \"us-west-2\"})"
  type        = map(string)
  default     = {}
}

variable "kubernetes_dashboard_yaml_values" {
  description = "List of Helm values in raw yaml for the kubernetes-dashboard Helm chart."
  type        = list(string)
  default     = []
}