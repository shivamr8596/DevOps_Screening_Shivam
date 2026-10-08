variable "vpc_id" {
  description = "ID of the VPC where the security groups will be created."
  type        = string
}

variable "application_port" {
  description = "Port used by the application server."
  type        = number
}

variable "alb_ingress_cidrs" {
  description = "CIDR blocks allowed to access the ALB."
  type        = list(string)
}

variable "alb_ingress_ports" {
  description = "Ports exposed by the ALB."
  type        = list(number)
}

variable "database_port" {
  description = "Port used by the PostgreSQL database."
  type        = number
}

variable "tags" {
  description = "Common tags applied to security groups."
  type        = map(string)
  default     = {}
}
