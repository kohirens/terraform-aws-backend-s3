variable "label" {
  default     = ""
  description = "Optional label to apply to all resources"
  type        = string
}

variable "tags" {
  default     = {}
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "use_s3_locking" {
  default     = true
  description = "Use S3 object locking or set to false to use legacy DynamoDB locking"
}
