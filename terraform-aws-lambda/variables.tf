variable "identifier" {
  description = "The name of the security group"
  type        = string
}

variable "iam_role" {
  description = "IAM role attached to the Lambda Function"
  type        = string
}

variable "handler" {
  description = "The function entrypoint in your code"
  type        = string
}

variable "sns_topic_arn" {
  description = "sns topic arn to send dead letter queue. Be aware that the function role will need Push permissions to the topic."
  default     = null
  type        = string
}

variable "runtime" {
  description = ""
  type        = string
}

variable "description" {
  description = "Description of what your Lambda Function does"
  default     = "Deployed by terraform"
  type        = string
}

variable "layers" {
  description = "List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function"
  default     = []
  type        = list(string)
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime"
  default     = 128
  type        = number
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds"
  default     = 3
  type        = number
}

variable "reserved_concurrent_executions" {
  description = "The amount of reserved concurrent executions for this lambda function"
  default     = -1
  type        = number
}

variable "publish" {
  description = "Whether to publish creation/change as new Lambda Function Version"
  default     = false
  type        = bool
}

variable "s3_bucket" {
  description = "The S3 bucket location containing the function's deployment package"
  default     = null
  type        = string
}

variable "s3_key" {
  description = "The S3 key of an object containing the function's deployment package"
  default     = null
  type        = string
}

variable "filename" {
  description = "Path to the function's deployment package within the local filesystem."
  default     = null
  type        = string
}

variable "source_code_hash" {
  description = "Used to trigger updates. Must be set to a base64-encoded SHA256 hash of the package file specified"
  type        = string
}

variable "security_group_ids" {
  description = "A list of security group IDs associated with the Lambda function"
  default     = []
  type        = list(string)
}

variable "subnet_ids" {
  description = "A list of subnet IDs associated with the Lambda function"
  default     = []
  type        = list(string)
}

variable "environment" {
  description = "A map that defines environment variables for the Lambda function"
  default     = {}
  type        = map(any)
}

variable "log_retention_in_days" {
  description = "Specifies the number of days you want to retain log"
  default     = 14
  type        = number
}

variable "event_source_arn" {
  description = "The event source ARN - can be a Kinesis stream, DynamoDB stream, or SQS queue. If specified set 'create_trigger' parameter to true"
  default     = null
  type        = string
}

variable "create_trigger" {
  description = "Set to true if you specify 'event_source_arn' parameter"
  default     = false
  type        = bool
}

variable "log_group_use_custom_kms_key" {
  description = "Set to 'true' if you are passing a custom KMS Key ARN"
  default     = false
  type        = bool
}

variable "log_group_kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data"
  default     = null
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
