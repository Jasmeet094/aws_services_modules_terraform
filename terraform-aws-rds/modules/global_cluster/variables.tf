variable "source_db_cluster_identifier" {
  description = "Amazon Resource Name (ARN) to use as the primary DB Cluster of the Global Cluster on creation"
  default     = null
  type        = string
}

variable "identifier" {
  description = "The global cluster identifier"
  type        = string
}

variable "deletion_protection" {
  description = "If the Global Cluster should have deletion protection enabled."
  default     = false
  type        = string
}

variable "storage_encrypted" {
  description = "Specifies whether the DB cluster is encrypted. Forces new resource"
  default     = true
  type        = string
}

variable "engine_version" {
  description = "Engine version of the Aurora global database. Upgrading the engine version will result in all cluster members being immediately updated"
  type        = string
}

variable "engine" {
  description = "Name of the database engine to be used for this DB cluster"
  type        = string
}

variable "database_name" {
  description = "Name for an automatically created database on cluster creation. Forces new resource"
  default     = "default"
  type        = string
}

variable "force_destroy" {
  description = "Enable to remove DB Cluster members from Global Cluster on destroy"
  default     = false
  type        = string
}

variable "append_workspace" {
  description = "Appends the terraform workspace at the end of resource names, <identifier>-<worspace>"
  default     = true
  type        = bool
}