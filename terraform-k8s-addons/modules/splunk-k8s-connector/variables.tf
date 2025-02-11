variable "helm_chart_version" {
  description = "Version of the splunk-k8s-connector Helm chart to use"
  type        = string
  default     = "1.4.7"
}

variable "namespace" {
  description = "namespace to deploy splunk-k8s-connector helm charts"
  type        = string
  default     = "splunk-k8s"
}

variable "values_file_path" {
  description = "helm chart values file path for perticular env"
  type        = string
}

variable "splunk_hec_token" {
  description = "provide hec token for splunk"
  type        = string
  sensitive   = true
}