variable "identifier" {
  description = "The name for the cluster"
  type        = string
}

variable "node_role_arn" {
  description = "Amazon Resource Name (ARN) of the IAM Role that provides permissions for the EKS Node Group"
  type        = string
}

variable "capacity_type" {
  description = "Type of capacity associated with the EKS Node Group. Valid values: ON_DEMAND, SPOT"
  default     = "ON_DEMAND"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
}

variable "subnet_ids" {
  description = "Identifiers of EC2 Subnets to associate with the EKS Node Group, must have the required tags"
  type        = list(string)
}

variable "ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Valid values: AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64"
  default     = "AL2_x86_64"
  type        = string
}

variable "instance_types" {
  description = "Set of instance types associated with the EKS Node Group"
  default     = ["t3.medium"]
  type        = list(string)
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  default     = 1
  type        = number
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  default     = 1
  type        = number
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  default     = 1
  type        = number
}

variable "labels" {
  description = "Key-value map of Kubernetes labels"
  default     = {}
  type        = map(string)
}

variable "taints" {
  description = "The Kubernetes taints to be applied to the nodes in the node group"
  default     = []
  type = list(object({
    effect = string
    value  = string
    key    = string
  }))
}

variable "tag_resource_types" {
  description = "List of resource types to tag"
  default = [
    "spot-instances-request",
    "elastic-gpu",
    "instance",
    "volume"
  ]
  type = list(string)
}

variable "metadata_options" {
  description = "The metadata options for the instances"
  default = {
    http_put_response_hop_limit = "1"
    http_endpoint               = "enabled"
    http_tokens                 = "required"
  }
  type = map(string)
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  default     = []
  type        = list(string)
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

variable "ssm_agent_enabled" {
  description = "Install the SSM agent on the worker nodes (requires proper IAM permissions to be set on the attached IAM Role)"
  default     = true
  type        = string
}

variable "block_device_mappings" {
  type        = list(any)
  description = <<-EOT
    List of block device mappings for the launch template.
    Each list element is an object with a `device_name` key and
    any keys supported by the `ebs` block of `launch_template`.
    EOT
  # See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template#ebs
  default = [{
    device_name           = "/dev/xvda"
    volume_size           = 20
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }]
}