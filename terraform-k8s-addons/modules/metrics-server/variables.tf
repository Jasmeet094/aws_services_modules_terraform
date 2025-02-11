variable "metrics_server_chart_version" {
  description = "Version of the metrics-server Helm chart to use"
  type        = string
  default     = "5.8.7"
}

variable "metrics_server_namespace" {
  description = "Kubernetes namespace to deploy the metrics-server controller"
  type        = string
  default     = "metrics-server"
}

variable "create_namespace" {
  description = "Should the namespace be newly created"
  type        = bool
  default     = true
}

variable "metrics_server_chart_values" {
  description = "Map of Helm values for the metrics-server Helm chart. (Eg. {aws.region = \"us-west-2\"})"
  type        = map(string)
  default     = {}
}

variable "metrics_server_yaml_values" {
  description = "List of Helm values in raw yaml for the metrics-server Helm chart."
  type        = list(string)
  default     = []
}