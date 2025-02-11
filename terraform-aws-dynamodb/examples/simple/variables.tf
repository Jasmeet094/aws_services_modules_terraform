variable "identifier" {
  description = "Name of the DynamoDB table"
  default     = "example"
  type        = string
}

variable "hash_key" {
  description = "The attribute to use as the hash (partition) key. Must also be defined as an attribute"
  default     = "Id"
  type        = string
}

variable "attributes" {
  description = "List of nested attribute definitions. Only required for hash_key and range_key attributes. Each attribute has two properties: name - (Required) The name of the attribute, type - (Required) Attribute type, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data"
  default = [
    {
      name = "Id"
      type = "S"
    }
  ]
  type = list(map(string))
}
