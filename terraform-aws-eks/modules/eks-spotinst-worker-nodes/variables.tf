variable "cluster_name" {
  description = "The name of the eks cluster"
  type        = string
}

variable "identifier" {
  description = "Identifier for the resources"
  type        = string
}

variable "region" {
  description = "The region where the resources will be deployed"
  default     = "us-west-2"
  type        = string
}

variable "kubernetes_version" {
  description = "Desired kubernetes master version"
  default     = "1.18"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnets to deploy the worker nodes in"
  type        = list(string)
}

variable "instance_types" {
  description = "List of instance types allowed for worker nodes"
  default     = ["t3.medium"]
  type        = list(string)
}

variable "security_groups" {
  description = "List of security groups to assign to the worker nodes"
  type        = list(string)
}

variable "key_name" {
  description = "Name of the EC2 key pair to assign to the worker nodes"
  type        = string
}

variable "iam_instance_profile" {
  description = "Arn of the IAM instance profile to use for the worker nodes"
  type        = string
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  default     = 10
  type        = number
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  default     = 1
  type        = number
}

variable "desired_capacity" {
  description = "Desired number of worker nodes"
  default     = 1
  type        = number
}

variable "root_volume_size" {
  description = "Size in GB of the worker nodes' root EBS volume"
  default     = 20
  type        = number
}

variable "associate_public_ip_address" {
  description = "Associate a public ip address to worker nodes"
  default     = false
  type        = bool
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
