variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment name"
}

variable "vpc_id" {
  type        = string
  description = "Id of the VPC where OpenVPN server will be deploy"
}

variable "ec2_instance_type" {
  type        = string
  description = "EC2 instance type for Openvpn server"
  default     = "t2.medium"
}

variable "key_name" {
  type        = string
  description = "EC2 Key name used for ssh access on the OpenVPN instance"
  default     = ""
}

variable "use_rds" {
  description = "Controls if RDS is used for storing OpenVPN configurations; default enabled"
  type        = bool
  default     = true
}

variable "openvpn_password" {
  type        = string
  description = "Initial password for the openvpn user"
}

variable "openvpn_dns" {
  type        = list(string)
  description = "Have VPN clients use these specific DNS servers"
  default     = ["10.0.0.20", "10.0.0.21"]
}

variable "openvpn_networks" {
  type        = list(string)
  description = "Private subnets to which all clients should be given access"
  default = ["10.0.0.0/16",
    "192.168.0.0/24"
  ]
}

variable "domain_name" {
  description = "The dns name of your OpenVPN deployment"
}

variable "hosted_zone_id" {
  description = "The hosted zone id"
  default     = ""
}

variable "ami_id" {
  description = "The AMI to use for openvpn instance, optional. If undefined the official openvpn marketplace image will be used"
  default     = ""
}

data "aws_ami" "openvpn" {
  most_recent = true
  filter {
    name   = "product-code"
    values = ["f2ew2wrz425a1jagnifd02u5t"] #BYOL - version https://aws.amazon.com/marketplace/pp/B00MI40CAE/
    #values = ["6nx35tuf44c0flgw09r1z9nrn"] #100 users version: https://aws.amazon.com/marketplace/pp/B01DE7Y902/
  }
  owners = ["679593333241"] # aws-marketplace
}

variable "db_instance_type" {
  type        = string
  default     = "db.t2.medium"
  description = " The instance class to use for RDS"
}

variable "rds_storage_encrypted" {
  default     = true
  description = "Specifies whether the DB cluster is encrypted"
}

variable "rds_master_name" {
  type        = string
  default     = "root"
  description = "Username for the master DB user"
}

variable "snapshot_identifier" {
  description = "(Optional) Specifies whether or not to restore the RDS from a snapshot; use the snapshot name"
  default     = ""
}

variable "rds_backup_retention_period" {
  type        = string
  default     = "7"
  description = "The days to retain backups for"
}

variable "apply_immediately" {
  type        = bool
  default     = false
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window. Default is false."
}

variable "public_subnet_ids" {
  description = "List of Public subnet IDs where VPN Instance will be created."
  type        = list(string)
  default     = []
}

variable "private_subnet_ids" {
  description = "List of Private subnet IDs where RDS Instance will be created."
  type        = list(string)
  default     = []
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