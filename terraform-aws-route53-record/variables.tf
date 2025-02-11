variable "records" {
  description = "(Required for non-alias records) A string list of records"
  default     = null
  type        = list(string)
}

variable "private_zone" {
  description = "Whether this is a private hosted zone or not (defaults to false)"
  default     = false
  type        = bool
}

variable "domain_name" {
  description = "The name of the hosted zone to use"
  type        = string
}

variable "name" {
  description = "The name of the record"
  type        = string
}

variable "type" {
  description = "The record type. Valid values are A, AAAA, CAA, CNAME, MX, NAPTR, NS, PTR, SOA, SPF, SRV and TXT"
  default     = "A"
  type        = string
}

variable "ttl" {
  description = "(Required for non-alias records) The TTL of the record"
  default     = null
  type        = number
}

variable "alias" {
  description = ""
  default     = []
  type = list(object({
    evaluate_target_health = bool,
    zone_id                = string,
    name                   = string
  }))
}
