variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_oidc_issuer_url" {
  description = "EKS Cluster OIDC issuer URL"
  type        = string
}

variable "external_dns_chart_version" {
  description = "Version of the external-dns Helm chart to use"
  type        = string
  default     = "4.11.0"
}

variable "external_dns_namespace" {
  description = "Kubernetes namespace to deploy the external-dns controller"
  type        = string
  default     = "kube-system"
}

variable "external_dns_chart_values" {
  description = "Map of Helm values for the external-dns Helm chart. (Eg. {aws.region = \"us-west-2\"})"
  type        = map(string)
  default     = {}
}

variable "external_dns_yaml_values" {
  description = "List of Helm values in raw yaml for the external-dns Helm chart."
  type        = list(string)
  default     = []
}

variable "external_dns_hosted_zone_ids" {
  description = "List of Route53 hosted zones ids to restrict the external-dns permissions"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map(any)
}