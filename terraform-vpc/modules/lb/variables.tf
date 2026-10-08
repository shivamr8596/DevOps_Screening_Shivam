variable "name" {
  description = "Name of the Application Load Balancer."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the ALB and target groups are created."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs where the ALB will be deployed."
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID assigned to the ALB."
  type        = string
}

variable "internal" {
  description = "Whether the load balancer is internal."
  type        = bool
  default     = false
}

variable "type" {
  description = "Type of load balancer."
  type        = string
  default     = "application"
}

variable "access_logs_bucket_id" {
  description = "S3 bucket ID used for ALB access logs."
  type        = string
}

variable "enable_access_logs" {
  description = "Whether ALB access logging is enabled."
  type        = bool
  default     = true
}

variable "lb_logs_prefix" {
  description = "Prefix used for ALB access logs."
  type        = string
  default     = "alb"
}

variable "lb_listener_port" {
  description = "Port on which the ALB listener accepts traffic."
  type        = number
  default     = 80
}

variable "lb_listener_protocol" {
  description = "Protocol used by the ALB listener."
  type        = string
  default     = "HTTP"

  validation {
    condition     = contains(["HTTP", "HTTPS"], var.lb_listener_protocol)
    error_message = "The listener protocol must be either HTTP or HTTPS."
  }
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate used by an HTTPS listener."
  type        = string
  default     = null
}

variable "default_target_group_name" {
  description = "Name of the target group used by the default listener action."
  type        = string
}

variable "target_groups" {
  description = "Target groups managed by the ALB."

  type = list(object({
    name        = string
    port        = number
    protocol    = string
    target_type = string

    health_check = optional(object({
      enabled             = optional(bool, true)
      path                = optional(string)
      protocol            = optional(string)
      port                = optional(string)
      interval            = optional(number)
      timeout             = optional(number)
      healthy_threshold   = optional(number)
      unhealthy_threshold = optional(number)
    }))
  }))
}

variable "attachments" {

  type = map(object({
    target_group_name = string
    target_id         = string
    port              = number
  }))

  default = {}
}

variable "listener_rules" {
  description = "Listener rules for path-based or host-based routing."

  type = list(object({
    priority          = number
    target_group_name = string

    path_patterns = optional(list(string))
    host_headers  = optional(list(string))
  }))

  default = []
}

variable "tags" {
  description = "Common tags applied to ALB resources."
  type        = map(string)
  default     = {}
}

