variable "identifier" {
  description = "Identifier for all resources"
  type        = string
}

variable "append_workspace" {
  description = "Appends the terraform workspace at the end of resource names, <identifier>-<worspace>"
  default     = true
  type        = bool
}

variable "subnets" {
  description = "List of subnet IDs used by database subnet group created"
  default     = []
  type        = list(string)
}

variable "replica_count" {
  description = "Number of reader nodes to create.  If `replica_scale_enable` is `true`, the value of `replica_scale_min` is used instead."
  default     = 1
  type        = number
}

variable "instance_type_replica" {
  description = "Instance type to use at replica instance"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "Instance type to use at master instance. If instance_type_replica is not set it will use the same type for replica instances"
  type        = string
  default     = ""
}

variable "publicly_accessible" {
  description = "Whether the DB should have a public IP address"
  default     = false
  type        = bool
}

variable "database_name" {
  description = "Name for an automatically created database on cluster creation"
  default     = "default_database"
  type        = string
}

variable "username" {
  description = "Master DB username"
  default     = "root"
  type        = string
}

variable "create_random_password" {
  description = "Whether to create random password for RDS primary cluster"
  default     = false
  type        = bool
}

variable "password" {
  description = "Master DB password. Note - when specifying a value here, 'create_random_password' should be set to `false`"
  default     = "" #tfsec:ignore:GEN001
  type        = string
}

variable "is_primary_cluster" {
  description = "Whether to create a primary cluster (set to false to be a part of a Global database)"
  default     = true
  type        = bool
}

variable "final_snapshot_identifier_prefix" {
  description = "The prefix name to use when creating a final snapshot on cluster destroy, appends a random 8 digits to name to ensure it's unique too."
  default     = "final"
  type        = string
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB cluster is deleted. If true is specified, no DB snapshot is created."
  default     = false
  type        = bool
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled"
  default     = false
  type        = bool
}

variable "backup_retention_period" {
  description = "How long to keep backups for (in days)"
  default     = 7
  type        = number
}

variable "preferred_backup_window" {
  description = "When to perform DB backups"
  default     = "02:00-03:00"
  type        = string
}

variable "preferred_maintenance_window" {
  description = "When to perform DB maintenance"
  default     = "sun:05:00-sun:06:00"
  type        = string
}

variable "port" {
  description = "The port on which to accept connections"
  default     = ""
  type        = string
}

variable "apply_immediately" {
  description = "Determines whether or not any DB modifications are applied immediately, or during the maintenance window"
  default     = false
  type        = bool
}

variable "monitoring_interval" {
  description = "The interval (seconds) between points when Enhanced Monitoring metrics are collected"
  default     = 0
  type        = number
}

variable "allow_major_version_upgrade" {
  description = "Determines whether major engine upgrades are allowed when changing engine version"
  default     = false
  type        = bool
}

variable "auto_minor_version_upgrade" {
  description = "Determines whether minor engine upgrades will be performed automatically in the maintenance window"
  default     = false
  type        = bool
}

variable "db_parameter_group_name" {
  description = "The name of a DB parameter group to use"
  default     = null
  type        = string
}

variable "db_cluster_parameter_group_name" {
  description = "The name of a DB Cluster parameter group to use"
  default     = null
  type        = string
}

variable "scaling_configuration" {
  description = "Map of nested attributes with scaling properties. Only valid when engine_mode is set to `serverless`"
  default     = {}
  type        = map(string)
}

variable "snapshot_identifier" {
  description = "DB snapshot to create this database from"
  default     = null
  type        = string
}

variable "storage_encrypted" {
  description = "Specifies whether the underlying storage layer should be encrypted"
  default     = true
  type        = bool
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key if one is set to the cluster"
  default     = null
  type        = string
}

variable "engine" {
  description = "Aurora database engine type, currently aurora, aurora-mysql or aurora-postgresql"
  default     = "aurora"
  type        = string
}

variable "engine_version" {
  description = "Aurora database engine version"
  default     = "5.6.10a"
  type        = string
}

variable "enable_http_endpoint" {
  description = "Whether or not to enable the Data API for a serverless Aurora database engine"
  default     = false
  type        = bool
}

variable "replica_scale_enabled" {
  description = "Whether to enable autoscaling for RDS Aurora (MySQL) read replicas"
  default     = false
  type        = bool
}

variable "replica_scale_max" {
  description = "Maximum number of read replicas permitted when autoscaling is enabled"
  default     = 0
  type        = number
}

variable "replica_scale_min" {
  description = "Minimum number of read replicas permitted when autoscaling is enabled"
  default     = 2
  type        = number
}

variable "replica_scale_cpu" {
  description = "CPU threshold which will initiate autoscaling"
  default     = 70
  type        = number
}

variable "replica_scale_connections" {
  description = "Average number of connections threshold which will initiate autoscaling. Default value is 70% of db.r4.large's default max_connections"
  default     = 700
  type        = number
}

variable "replica_scale_in_cooldown" {
  description = "Cooldown in seconds before allowing further scaling operations after a scale in"
  default     = 300
  type        = number
}

variable "replica_scale_out_cooldown" {
  description = "Cooldown in seconds before allowing further scaling operations after a scale out"
  default     = 300
  type        = number
}

variable "tags" {
  description = "A map of tags to add to all resources."
  default     = {}
  type        = map(string)
}

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights is enabled or not"
  default     = false
  type        = bool
}

variable "performance_insights_kms_key_id" {
  description = "The ARN for the KMS key to encrypt Performance Insights data"
  default     = ""
  type        = string
}

variable "iam_database_authentication_enabled" {
  description = "Specifies whether IAM Database authentication should be enabled or not. Not all versions and instances are supported. Refer to the AWS documentation to see which versions are supported"
  default     = false
  type        = bool
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to cloudwatch - `audit`, `error`, `general`, `slowquery`, `postgresql`"
  default     = []
  type        = list(string)
}

variable "global_cluster_identifier" {
  description = "The global cluster identifier specified on aws_rds_global_cluster"
  default     = ""
  type        = string
}

variable "engine_mode" {
  description = "The database engine mode. Valid values: global, parallelquery, provisioned, serverless, multimaster"
  default     = "provisioned"
  type        = string
}

variable "replication_source_identifier" {
  description = "ARN of a source DB cluster or DB instance if this DB cluster is to be created as a Read Replica"
  default     = ""
  type        = string
}

variable "source_region" {
  description = "The source region for an encrypted replica DB cluster"
  default     = ""
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate to the cluster"
  default     = []
  type        = list(string)
}

variable "security_groups_ingress" {
  description = "List of security groups to allow ingress traffic to RDS"
  default     = []
  type        = list(string)
}

variable "cidr_block_ingress" {
  description = "List of cidr bloks to allow ingress to RDS"
  default     = []
  type        = list(string)
}

variable "db_subnet_group_name" {
  description = "The existing subnet group name to use"
  default     = ""
  type        = string
}

variable "predefined_metric_type" {
  description = "The metric type to scale on. Valid values are RDSReaderAverageCPUUtilization and RDSReaderAverageDatabaseConnections"
  default     = "RDSReaderAverageCPUUtilization"
  type        = string
}

variable "backtrack_window" {
  description = "The target backtrack window, in seconds. Only available for aurora engine currently. To disable backtracking, set this value to 0. Must be between 0 and 259200 (72 hours)"
  default     = 0
  type        = number
}

variable "copy_tags_to_snapshot" {
  description = "Copy all Cluster tags to snapshots"
  default     = true
  type        = bool
}

variable "iam_roles" {
  description = "A List of ARNs for the IAM roles to associate to the RDS Cluster"
  default     = []
  type        = list(string)
}

variable "ca_cert_identifier" {
  description = "The identifier of the CA certificate for the DB instance"
  default     = "rds-ca-2019"
  type        = string
}

variable "instances_parameters" {
  description = "Customized instance settings. Supported keys: `instance_name`, `instance_type`, `instance_promotion_tier`, `publicly_accessible`"
  default     = []
  type        = list(map(string))
}

variable "s3_import" {
  description = "Configuration map used to restore from a Percona Xtrabackup in S3 (only MySQL is supported)"
  default     = null
  type        = map(string)
}

variable "create_monitoring_role" {
  description = "Whether to create the IAM role for RDS enhanced monitoring"
  default     = true
  type        = bool
}

variable "monitoring_role_arn" {
  description = "IAM role used by RDS to send enhanced monitoring metrics to CloudWatch"
  default     = ""
  type        = string
}

variable "iam_role_name" {
  description = "Friendly name of the role"
  default     = null
  type        = string
}

variable "iam_role_use_name_prefix" {
  description = "Whether to use `iam_role_name` as is or create a unique name beginning with the `iam_role_name` as the prefix"
  default     = false
  type        = bool
}

variable "iam_role_description" {
  description = "Description of the role"
  default     = null
  type        = string
}

variable "iam_role_path" {
  description = "Path to the role"
  default     = null
  type        = string
}

variable "iam_role_managed_policy_arns" {
  description = "Set of exclusive IAM managed policy ARNs to attach to the IAM role"
  default     = null
  type        = list(string)
}

variable "iam_role_permissions_boundary" {
  description = "The ARN of the policy that is used to set the permissions boundary for the role"
  default     = null
  type        = string
}

variable "iam_role_force_detach_policies" {
  description = "Whether to force detaching any policies the role has before destroying it"
  default     = null
  type        = bool
}

variable "iam_role_max_session_duration" {
  description = "Maximum session duration (in seconds) that you want to set for the role"
  default     = null
  type        = number
}