variable "identifier" {
  description = "The name for the cluster"
  type        = string
}

variable "policy_arns" {
  description = "List of policy arns to attach to the cluster IAM role"
  default     = []
  type        = list(string)
}

variable "eks_version" {
  description = "Desired Kubernetes master version"
  default     = "1.24"
  type        = string
}

variable "eks_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS API server is public"
  default     = false
  type        = bool
}

variable "eks_endpoint_private_access" {
  description = "Indicates whether the Amazon EKS private API server endpoint is enabled"
  default     = true
  type        = bool
}

variable "public_access_cidrs" {
  description = "Indicates which CIDR blocks can access the Amazon EKS API server endpoint"
  default     = []
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs to allow communication between your worker nodes and the Kubernetes control plane"
  default     = []
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs. Must be in at least two different availability zones"
  type        = list(string)
}

variable "create_oidc_provider" {
  description = "Create or not an OIDC Provider resource for the cluster. Default 'true'"
  default     = true
  type        = bool
}

variable "thumbprint_list" {
  description = "A list of server certificate thumbprints for the OpenID Connect (OIDC) identity provider's server certificate(s)"
  default     = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"] # Thumbprint of Root CA for EKS OIDC, Valid until 2037
  type        = list(string)
}

variable "client_id_list" {
  description = "A list of client IDs (also known as audiences)"
  default     = ["sts.amazonaws.com"]
  type        = list(string)
}

variable "enabled_cluster_log_types" {
  description = "A list of the desired control plane logging to enable"
  default     = ["api", "authenticator", "audit", "scheduler", "controllerManager"]
  type        = list(string)
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map(any)
}

variable "append_workspace" {
  description = "Appends the terraform workspace at the end of resource names, <identifier>-<worspace>"
  default     = true
  type        = bool
}

variable "log_group_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group"
  default     = 30
  type        = number

  validation {
    condition     = contains([0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.log_group_retention_in_days)
    error_message = "Valid values for log_group_retention_in_days are 0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653."
  }

}