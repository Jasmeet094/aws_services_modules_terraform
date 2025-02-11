variable "identifier" {
  description = "Identifier to name resources"
  type        = string
}

variable "append_workspace" {
  description = "appends the terraform workspace at the end of the identifier like <identifier>-<workspace>"
  default     = true
  type        = bool
}

variable "name" {
  description = "Name to be used on EC2 instance created"
  default     = ""
  type        = string
}

variable "ami" {
  description = "ID of AMI to use for the instance"
  default     = ""
  type        = string
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  default     = null
  type        = bool
}

variable "availability_zone" {
  description = "AZ to start the instance in"
  default     = null
  type        = string
}

variable "capacity_reservation_specification" {
  description = "Describes an instance's Capacity Reservation targeting option"
  default     = null
  type        = any
}

variable "cpu_credits" {
  description = "The credit option for CPU usage (unlimited or standard)"
  default     = null
  type        = string
}

variable "disable_api_termination" {
  description = "If true, enables EC2 Instance Termination Protection"
  default     = null
  type        = bool
}

variable "ebs_block_device" {
  description = "Additional EBS block devices to attach to the instance"
  default     = []
  type        = list(map(string))
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  default     = null
  type        = bool
}

variable "enclave_options_enabled" {
  description = "Whether Nitro Enclaves will be enabled on the instance. Defaults to `false`"
  default     = null
  type        = bool
}

variable "ephemeral_block_device" {
  description = "Customize Ephemeral (also known as Instance Store) volumes on the instance"
  default     = []
  type        = list(map(string))
}

variable "get_password_data" {
  description = "If true, wait for password data to become available and retrieve it."
  type        = bool
  default     = null
}

variable "hibernation" {
  description = "If true, the launched EC2 instance will support hibernation"
  default     = null
  type        = bool
}

variable "host_id" {
  description = "ID of a dedicated host that the instance will be assigned to. Use when an instance is to be launched on a specific dedicated host"
  default     = null
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile"
  default     = null
  type        = string
}

variable "instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior for the instance. Amazon defaults this to stop for EBS-backed instances and terminate for instance-store instances. Cannot be set on instance-store instance" # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/terminating-instances.html#Using_ChangingInstanceInitiatedShutdownBehavior
  default     = null
  type        = string
}

variable "instance_type" {
  description = "The type of instance to start"
  default     = "t3.micro"
  type        = string
}

variable "ipv6_address_count" {
  description = "A number of IPv6 addresses to associate with the primary network interface. Amazon EC2 chooses the IPv6 addresses from the range of your subnet"
  type        = number
  default     = null
}

variable "ipv6_addresses" {
  description = "Specify one or more IPv6 addresses from the range of the subnet to associate with the primary network interface"
  default     = null
  type        = list(string)
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  default     = null
  type        = string
}

variable "launch_template" {
  description = "Specifies a Launch Template to configure the instance. Parameters configured on this resource will override the corresponding parameters in the Launch Template"
  default     = null
  type        = map(string)
}

variable "metadata_options" {
  description = "Customize the metadata options of the instance"
  default     = {}
  type        = map(string)
}

variable "monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled"
  default     = false
  type        = bool
}

variable "network_interface" {
  description = "Customize network interfaces to be attached at instance boot time"
  default     = []
  type        = list(map(string))
}

variable "placement_group" {
  description = "The Placement Group to start the instance in"
  default     = null
  type        = string
}

variable "private_ip" {
  description = "Private IP address to associate with the instance in a VPC"
  default     = null
  type        = string
}

variable "associate_eip_address" {
  description = "Whether to associate an elastic IP to the instance"
  default     = false
  type        = bool
}

variable "eip_allocation_id" {
  description = "elastic ip to associate to instance if not specified a new ip is reserved"
  default     = null
  type        = string
}

variable "root_block_device" {
  description = "Customize details about the root block device of the instance. See Block Devices below for details"
  default     = []
  type        = list(any)
}

variable "secondary_private_ips" {
  description = "A list of secondary private IPv4 addresses to assign to the instance's primary network interface (eth0) in a VPC. Can only be assigned to the primary network interface (eth0) attached at instance creation, not a pre-existing network interface i.e. referenced in a `network_interface block`"
  default     = null
  type        = list(string)
}

variable "source_dest_check" {
  description = "Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs."
  default     = true
  type        = bool
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  default     = null
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  default     = {}
  type        = map(string)
}

variable "tenancy" {
  description = "The tenancy of the instance (if the instance is running in a VPC). Available values: default, dedicated, host."
  default     = null
  type        = string
}

variable "user_data" {
  description = "The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user_data_base64 instead."
  default     = null
  type        = string
}

variable "user_data_base64" {
  description = "Can be used instead of user_data to pass base64-encoded binary data directly. Use this instead of user_data whenever the value is not a valid UTF-8 string. For example, gzip-encoded user data must be base64-encoded and passed via this argument to avoid corruption."
  default     = null
  type        = string
}

variable "volume_tags" {
  description = "A mapping of tags to assign to the devices created by the instance at launch time"
  default     = {}
  type        = map(string)
}

variable "enable_volume_tags" {
  description = "Whether to enable volume tags (if enabled it conflicts with root_block_device tags)"
  default     = true
  type        = bool
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  default     = null
  type        = list(string)
}

variable "timeouts" {
  description = "Define maximum timeout for creating, updating, and deleting EC2 instance resources"
  default     = {}
  type        = map(string)
}

variable "cpu_core_count" {
  description = "Sets the number of CPU cores for an instance." # This option is only supported on creation of instance type that support CPU Options https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-optimize-cpu.html#cpu-options-supported-instances-values
  default     = null
  type        = number
}

variable "cpu_threads_per_core" {
  description = "Sets the number of CPU threads per core for an instance (has no effect unless cpu_core_count is also set)."
  default     = null
  type        = number
}

# Spot instance request
variable "create_spot_instance" {
  description = "Depicts if the instance is a spot instance"
  default     = false
  type        = bool
}

variable "spot_price" {
  description = "The maximum price to request on the spot market. Defaults to on-demand price"
  default     = null
  type        = string
}

variable "spot_wait_for_fulfillment" {
  description = "If set, Terraform will wait for the Spot Request to be fulfilled, and will throw an error if the timeout of 10m is reached"
  default     = null
  type        = bool
}

variable "spot_type" {
  description = "If set to one-time, after the instance is terminated, the spot request will be closed. Default `persistent`"
  default     = null
  type        = string
}

variable "spot_launch_group" {
  description = "A launch group is a group of spot instances that launch together and terminate together. If left empty instances are launched and terminated individually"
  default     = null
  type        = string
}

variable "spot_block_duration_minutes" {
  description = "The required duration for the Spot instances, in minutes. This value must be a multiple of 60 (60, 120, 180, 240, 300, or 360)"
  default     = null
  type        = number
}

variable "spot_instance_interruption_behavior" {
  description = "Indicates Spot instance behavior when it is interrupted. Valid values are `terminate`, `stop`, or `hibernate`"
  default     = null
  type        = string
}

variable "spot_valid_until" {
  description = "The end date and time of the request, in UTC RFC3339 format(for example, YYYY-MM-DDTHH:MM:SSZ)"
  default     = null
  type        = string
}

variable "spot_valid_from" {
  description = "The start date and time of the request, in UTC RFC3339 format(for example, YYYY-MM-DDTHH:MM:SSZ)"
  default     = null
  type        = string
}