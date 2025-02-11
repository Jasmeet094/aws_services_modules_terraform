variable "datadog_crds_helm_chart_version" {
  description = "Version of the datadog-crds Helm chart to use"
  type        = string
  default     = "0.3.1"
}

variable "datadog_agents_helm_chart_version" {
  description = "Version of the datadog Helm chart to use"
  type        = string
  default     = "2.15.6"
}

variable "namespace" {
  description = "namespace to deploy datadog helm charts"
  type        = string
  default     = "datadog"
}

variable "datadog_agents_api_key" {
  description = "provide api key for datadog"
  type        = string
  sensitive   = true
}

variable "datadog_agents_app_key" {
  description = "provide application key for datadog"
  type        = string
  sensitive   = true
}