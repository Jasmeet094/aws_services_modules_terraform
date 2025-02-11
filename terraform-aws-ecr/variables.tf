variable "identifier" {
  description = "(Required) Name of the repository"
  type        = string
}

variable "scan_on_push" {
  description = "(Optional) Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false). Defaults to true"
  default     = true
  type        = bool
}

variable "image_tag_mutability" {
  description = "(Optional) The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE. Defaults to MUTABLE"
  default     = "IMMUTABLE"
  type        = string
}

variable "tags" {
  description = "(Optional) A map of tags to assign to the resource"
  default     = {}
  type        = map(any)
}

variable "policy" {
  description = "The lifecycle policy to delete images older than 14 days"
  type        = string
  default     = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 14 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 14
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

variable "ecr_allowed_access" {
  description = "AWS Account IDs or user ARNs for cross account access"
  default     = []
  type        = list(string)
}

variable "repo_policy" {
  description = "The repo policy to allow access/control on the repo. Needs to be a fully formatted JSON policy and it overrides the 'ecr_allowed_access' variable. If blank a default policy is set in the locals"
  type        = string
  default     = ""
}

variable "encryption_type" {
  description = "The encryption type to use for the repository. Valid values are AES256 or KMS. Defaults to AES256"
  default     = "KMS"
  type        = string
}

variable "kms_arn" {
  description = "The ARN of the KMS key to use when encryption_type is KMS. If not specified, uses the default AWS managed key for ECR."
  default     = null
  type        = string
}

variable "append_workspace" {
  description = "Appends the terraform workspace at the end of resource names, <identifier>-<worspace>"
  default     = true
  type        = bool
}