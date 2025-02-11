variable "identifier" {
  description = "A name for all resources"
  type        = string
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key. When specifying kms_key_id, encrypted needs to be set to true"
  default     = null
  type        = string
}

variable "encrypted" {
  description = "If true, the disk will be encrypted"
  default     = true
  type        = bool
}

variable "performance_mode" {
  description = "The file system performance mode"
  default     = "generalPurpose"
  type        = string
}

variable "throughput_mode" {
  description = "Throughput mode for the file system"
  default     = "bursting"
  type        = string
}

variable "provisioned_throughput_in_mibps" {
  description = "The throughput, measured in MiB/s, that you want to provision for the file system. Only applicable with throughput_mode set to provisioned"
  default     = null
  type        = string
}

variable "security_groups" {
  description = "List of security groups to assign to all the EFS mount points"
  default     = []
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnets ids to deploy EFS mount points in"
  default     = []
  type        = list(string)
}

variable "append_workspace" {
  description = "Appends the terraform workspace at the end of resource names, <identifier>-<worspace>"
  default     = true
  type        = bool
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map(any)
}