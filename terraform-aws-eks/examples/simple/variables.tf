variable "identifier" {
  description = "ID for all resources"
  default     = "example"
  type        = string
}

variable "key_name" {
  description = "Keypair to use"
  default     = "nclouds-tf"
  type        = string
}

variable "instance_type" {
  description = "Instance type to use"
  default     = "t3.medium"
  type        = string
}
