variable "bucket_name" {
  type        = string
  description = "Name of bucket"
}

variable "elb_service_account_arn" {
  type        = string
  description = "Service account"
}

variable "common_tags" {
  type        = map(string)
  description = "Map of tags to be applied to all resources"
  default     = {}
}