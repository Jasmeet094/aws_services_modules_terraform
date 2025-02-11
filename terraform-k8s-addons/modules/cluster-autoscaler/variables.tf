variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_oidc_issuer_url" {
  description = "EKS Cluster OIDC issuer URL"
  type        = string
}

variable "cluster_autoscaler_chart_version" {
  description = "Version of the cluster-autoscaler Helm chart to use"
  type        = string
  default     = "9.9.2"
}

variable "cluster_autoscaler_namespace" {
  description = "Kubernetes namespace to deploy the cluster-autoscaler controller"
  type        = string
  default     = "kube-system"
}

variable "cluster_autoscaler_chart_values" {
  description = "Map of Helm values for the cluster-autoscaler Helm chart. (Eg. {aws.region = \"us-west-2\"})"
  type        = map(string)
  default = {
    "extraArgs.balance-similar-node-groups"   = "true"
    "extraArgs.skip-nodes-with-system-pods"   = "false"
    "extraArgs.skip-nodes-with-local-storage" = "false"
    "extraArgs.expander"                      = "least-waste"
  }
}

variable "cluster_autoscaler_yaml_values" {
  description = "List of Helm values in raw yaml for the cluster-autoscaler Helm chart."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map(any)
}