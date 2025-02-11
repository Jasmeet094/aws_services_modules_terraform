variable "identifier" {
  description = "A name identifier for the ElasticSearch domain."
  default     = ""
  type        = string
}

variable "security_group_ids" {
  description = "List of security group ids."
  default     = []
  type        = list(string)
}

variable "subnets_ids" {
  description = "List of all the subnets"
  default     = []
  type        = list(string)
}

variable "ebs_enabled" {
  description = "Whether EBS volumes are attached to data nodes in the domain."
  default     = true
  type        = bool
}

variable "volume_size" {
  description = "The size of EBS volumes attached to data nodes (in GB)."
  default     = 20
  type        = number
}

variable "iops" {
  description = "The baseline input/output (I/O) performance of EBS volumes attached to data nodes"
  default     = 0
  type        = number
}

variable "zone_awareness_enabled" {
  description = "Configuration block containing zone awareness settings. Documented below."
  default     = false
  type        = bool
}

variable "instance_type" {
  description = "Instance type of data nodes in the cluster."
  default     = ""
  type        = string
}

variable "volume_type" {
  description = "The type of EBS volumes attached to data nodes."
  default     = "gp2"
  type        = string
}

variable "instance_count" {
  description = "The number of data nodes (instances) to use in the Amazon ES domain"
  default     = 1
  type        = number
}

variable "dedicated_master_enabled" {
  description = "Indicates whether dedicated master nodes are enabled for the cluster."
  default     = false
  type        = bool
}

variable "elasticsearch_version" {
  description = "The version of Elasticsearch to use."
  type        = string
}

variable "dedicated_master_type" {
  description = "Instance type of the dedicated master nodes in the cluster."
  default     = ""
  type        = string
}

variable "dedicated_master_count" {
  description = "Number of dedicated master nodes in the cluster."
  default     = 1
  type        = number
}

variable "master_user" {
  description = "master username for advanced security options"
  default     = "username"
  type        = string
}

variable "master_password" {
  description = "master password for advanced security options"
  default     = null
  type        = string
}

variable "enforce_https" {
  description = "Enforce https option"
  default     = true
  type        = bool
}

variable "tls_security_policy" {
  description = "tls encryption security policy version"
  default     = "Policy-Min-TLS-1-2-2019-07"
  type        = string
}

variable "encryption_in_transit" {
  description = "Encryption in transit"
  default     = true
  type        = bool
}

variable "advanced_security" {
  description = "enable advanced security options"
  default     = true
  type        = bool
}

variable "internal_db" {
  description = "enable internal user database for advanced security options"
  default     = true
  type        = bool
}

variable "log_publish" {
  description = "enable log publishing"
  default     = true
  type        = bool
}

variable "encryption_at_rest" {
  description = "enable encryption at rest"
  default     = true
  type        = bool
}

variable "automated_snapshot_start_hour" {
  description = "Hour during which the service takes an automated daily snapshot of the indices in the domain."
  default     = 0
  type        = number
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
