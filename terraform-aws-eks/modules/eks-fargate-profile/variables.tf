variable "identifier" {
  description = "The name for the cluster"
  type        = string
}

variable "pod_execution_role_arn" {
  description = "Amazon Resource Name (ARN) of the IAM Role that provides permissions for the EKS Fargate Profile"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
}

variable "subnet_ids" {
  description = "Identifiers of private EC2 Subnets to associate with the EKS Fargate Profile. These subnets must have the following resource tag: kubernetes.io/cluster/CLUSTER_NAME"
  type        = list(string)
}


variable "profile_selectors" {
  type = list(object({
    namespace = string
    labels    = map(any)
  }))
  description = "selectors by namespace"
}

variable "tags" {
  description = "Tags to be applied to all resources"
  default     = {}
  type        = map(any)
}

variable "append_workspace" {
  description = "Appends the terraform workspace at the end of resource names, <identifier>-<worspace>"
  default     = true
  type        = bool
}
