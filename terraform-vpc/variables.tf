variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"

  validation {
    condition = contains([
      "us-east-1", "us-east-2", "us-west-1", "us-west-2",
      "eu-west-1", "eu-west-2", "eu-central-1", "ap-southeast-1"
    ], var.aws_region)

    error_message = "The aws_region variable must be a valid, allowed AWS region."
  }
}

variable "aws_vpc_cidr" {
  description = "VPC cidr block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public cidr blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  validation {
    condition     = length(var.public_subnet_cidrs) >= 3
    error_message = "Atleast 3 public subnet cidr blocks required."
  }
}

variable "private_subnet_cidrs" {
  description = "Private cidr blocks"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  validation {
    condition     = length(var.private_subnet_cidrs) >= 3
    error_message = "Atleast 3 private subnet cidr blocks required."
  }
}

variable "vpc_availability_zones" {
  description = "VPC availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]

  validation {
    condition     = length(var.vpc_availability_zones) >= 3
    error_message = "Atleast 3 availability zones required."
  }
}

variable "destination_cidr_block" {
  description = "The destination cidr block for public internet access."
  type        = string
  default     = "0.0.0.0/0"
}

variable "allowed_ips" {
  description = "Public IP to allow"
  type        = set(string)
  default     = ["132.154.64.35/32"]

  validation {
    condition     = length(var.allowed_ips) >= 1
    error_message = "Atleast 1 IP is required."
  }
}

variable "ec2_ingress_rules" {
  description = "Ingress Rules for allowing specific IPs for RDP for EC2 instance."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

  default = null
}

variable "ec2_egress_rules" {
  description = "Egress Rules for EC2 instance."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

  default = [{
    description = "EC2 instance egress rules."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

variable "instances" {
  description = "EC2 instance configuration"

  type = map(object({
    instance_type               = string
    name                        = string
    associate_public_ip_address = bool

    root_block_device = object({
      volume_size           = number
      volume_type           = string
      iops                  = number
      throughput            = number
      encrypted             = bool
      delete_on_termination = bool
    })
  }))
}

