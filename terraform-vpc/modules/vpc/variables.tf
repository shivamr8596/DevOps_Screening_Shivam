variable "aws_vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets."
  type        = list(string)
}

variable "vpc_availability_zones" {
  description = "Availability zones used by the VPC subnets."
  type        = list(string)
}

variable "destination_cidr_block" {
  description = "Destination CIDR block for the public route."
  type        = string
}

variable "tags" {
  description = "Common tags applied to VPC resources."
  type        = map(string)
  default     = {}
}

variable "application_port" {
  type = number
}

variable "database_port" {
  type = number
}

variable "alb_ingress_ports" {
  type = list(number)
}

variable "alb_ingress_cidrs" {
  type = list(string)
}
