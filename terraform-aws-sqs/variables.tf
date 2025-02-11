variable "identifier" {
  description = "The identifier for the resources"
  type        = string
}

variable "dead_letter_queue" {
  description = "set to 'true' to deploy a DeadLetterQueue"
  default     = false
  type        = bool
}

variable "delay_seconds" {
  description = "The time in seconds that the delivery of all messages in the queue will be delayed"
  default     = 90
  type        = number
}

variable "max_message_size" {
  description = "The limit of how many bytes a message can contain before Amazon SQS rejects it"
  default     = 2048
  type        = number
}

variable "message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message"
  default     = 345600
  type        = number
}

variable "message_retention_seconds_dlq" {
  description = "The number of seconds Amazon SQS retains a message in the Dead Letter Queue"
  default     = 345600
  type        = number
}

variable "receive_wait_time_seconds" {
  description = "The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning"
  default     = 10
  type        = number
}

variable "max_receive_count" {
  description = "Max number of times a message can be received before it gets put in the Dead Letter Queue"
  default     = 5
  type        = number
}

variable "fifo_queue" {
  description = "Boolean designating a FIFO queue, defaults to a standard queue"
  default     = false
  type        = bool
}

variable "content_based_deduplication" {
  description = "Enables content-based deduplication for FIFO queues"
  default     = false
  type        = bool
}

variable "visibility_timeout_seconds" {
  description = "The visibility timeout for the queue. An integer from 0 to 43200 (12 hours)"
  default     = 30
  type        = number
}

variable "kms_master_key_id" {
  description = "The ID of an AWS-managed customer master key "
  default     = "alias/aws/sqs"
  type        = string
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

variable "policy" {
  description = "The JSON policy for the SQS queue"
  default     = null
  type        = string
}
