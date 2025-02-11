variable "enable" {
  description = "Tag to enable disable monitors creation"
  default     = false
  type        = bool
}

variable "name" {
  description = "The title/name of monitor"
  type        = string
}

variable "type" {
  description = "Defining monitor type"
  type        = string
}

variable "query" {
  description = "The monitor query"
  type        = string
}

variable "message" {
  description = "Initial message to add in monitor"
  type        = string
}

variable "thresholds" {
  description = "warning,critical,ok thresholds"
  default     = {}
  type        = map(any)
}

variable "renotify_interval" {
  description = "Interval for renotification if monitor is in triggered state."
  default     = 90
  type        = number
}

variable "new_host_delay" {
  description = "Delay evaluation for new host."
  default     = 300
  type        = number
}

variable "no_data_timeframe" {
  description = "Timeframe for no dfata notification."
  default     = 20
  type        = number
}

variable "notify_no_data" {
  description = "No data notification"
  default     = true
  type        = bool
}

variable "notify_audit" {
  description = "Set true to get notification on monitor modification."
  default     = false
  type        = bool
}

variable "require_full_window" {
  description = "Option for setting full window evaluation for datadog monitor."
  default     = true
  type        = bool
}

variable "include_tags" {
  description = "Option for setting up tag inclusion in monitor title while triggering."
  default     = true
  type        = bool
}

variable "tags" {
  description = "Add values to set tags for monitor."
  default     = {}
  type        = map(any)
}
