variable "identifier" {
  description = "The name for the cluster"
  type        = string
}

variable "append_workspace" {
  description = "Appends the terraform workspace at the end of resource names, <identifier>-<worspace>"
  default     = true
  type        = bool
}

variable "file_system_id" {
  description = "ID of the file system for which the access point is intended."
  type        = string
}

variable "posix_gid" {
  description = "POSIX group ID used for all file system operations using this access point"
  default     = 0
  type        = number
}

variable "posix_uid" {
  description = "POSIX user ID used for all file system operations using this access point"
  default     = 0
  type        = number
}

variable "path" {
  description = "Path on the EFS file system to expose as the root directory to NFS clients using the access point to access the EFS file system"
  default     = "/"
  type        = string
}

variable "owner_gid" {
  description = "POSIX group ID to apply to the root_directory"
  default     = 0
  type        = number
}

variable "owner_uid" {
  description = "POSIX user ID to apply to the root_directory"
  default     = 0
  type        = number
}

variable "permissions" {
  description = "POSIX permissions to apply to the RootDirectory, in the format of an octal number representing the file's mode bits"
  default     = 777
  type        = number
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map(any)
}