variable "description" {
  description = "A description for the security group"
  default     = "Security group created by terraform"
  type        = string
}

variable "identifier" {
  description = "The name of the security group"
  type        = string
}

variable "vpc_id" {
  description = "The id of the VPC where the security group is being deployed"
  type        = string
}

variable "ingress_rule_list" {
  description = "List of security group ingress rules with a CIDR specified"
  default     = []
  type = list(object({
    cidr_blocks = list(string),
    description = string,
    from_port   = number,
    protocol    = string,
    to_port     = number
  }))
}

variable "ingress_from_security_group_list" {
  description = "List of security group ingress rules that specify another Security Group rather than a CIDR"
  default     = []
  type = list(object({
    source_security_group_id = string,
    description              = string,
    from_port                = number,
    protocol                 = string,
    to_port                  = number
  }))
}

variable "egress_rule_list" {
  description = "List of security group egress rules"
  default = [
    {
      cidr_blocks = ["0.0.0.0/0"],
      description = "Default egress rule",
      from_port   = 0,
      protocol    = "all",
      to_port     = 65535
    }
  ]
  type = list(object({
    cidr_blocks = list(string),
    description = string,
    from_port   = number,
    protocol    = string,
    to_port     = number
  }))
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map(any)
}

variable "self_rule" {
  description = "Set to 'true' to create a self ingress rule in the security group"
  default     = false
  type        = bool
}

variable "append_workspace" {
  description = "Appends the terraform workspace at the end of resource names, <identifier>-<worspace>"
  default     = true
  type        = bool
}
