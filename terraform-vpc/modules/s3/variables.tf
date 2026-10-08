variable "name" {
  description = "Name of the S3 bucket."
  type        = string
}

variable "force_destroy" {
  description = "Whether the bucket can be destroyed even when it contains objects."
  type        = bool
  default     = true
}

variable "logs_prefix" {
  description = "Prefix used for ALB access logs."
  type        = string
  default     = "alb-logs"
}

variable "tags" {
  description = "Common tags applied to the S3 bucket."
  type        = map(string)
  default     = {}
}
