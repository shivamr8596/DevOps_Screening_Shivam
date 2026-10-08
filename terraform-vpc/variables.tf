variable "aws_region" {
  description = "AWS region."
  type        = string
  default     = "us-east-1"

  validation {
    condition = contains([
      "us-east-1",
      "us-east-2",
      "us-west-1",
      "us-west-2",
      "eu-west-1",
      "eu-west-2",
      "eu-central-1",
      "ap-southeast-1"
    ], var.aws_region)

    error_message = "The aws_region variable must be a valid, allowed AWS region."
  }
}


variable "aws_vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}


variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets."
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]

  validation {
    condition     = length(var.public_subnet_cidrs) >= 2
    error_message = "At least 2 public subnet CIDR blocks are required."
  }
}


variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets."
  type        = list(string)
  default = [
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24"
  ]

  validation {
    condition     = length(var.private_subnet_cidrs) >= 2
    error_message = "At least 2 private subnet CIDR blocks are required."
  }
}


variable "vpc_availability_zones" {
  description = "Availability zones used by the VPC subnets."
  type        = list(string)
  default = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c"
  ]

  validation {
    condition     = length(var.vpc_availability_zones) >= 2
    error_message = "At least 2 availability zones are required."
  }
}


variable "destination_cidr_block" {
  description = "Destination CIDR block for public internet access."
  type        = string
  default     = "0.0.0.0/0"
}


variable "ec2_instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}


variable "ec2_root_volume_size" {
  description = "Root EBS volume size in GB."
  type        = number
  default     = 40
}


variable "ec2_root_volume_type" {
  description = "Root EBS volume type."
  type        = string
  default     = "gp3"
}


variable "ec2_root_volume_iops" {
  description = "IOPS for the root EBS volume."
  type        = number
  default     = 6000
}


variable "ec2_root_volume_throughput" {
  description = "Throughput for the root EBS volume in MiB/s."
  type        = number
  default     = 250
}


variable "postgres_engine_version" {
  description = "PostgreSQL engine version."
  type        = string
}


variable "postgres_db_name" {
  description = "Initial PostgreSQL database name."
  type        = string
}


variable "postgres_username" {
  description = "PostgreSQL master username."
  type        = string
}


variable "postgres_password" {
  description = "PostgreSQL master password."
  type        = string
  sensitive   = true
}


variable "postgres_allocated_storage" {
  description = "Allocated PostgreSQL storage in GB."
  type        = number
  default     = 20
}

variable "application_port" {
  description = "Port used by the application running on the EC2 instance."
  type        = number
  default     = 8080
}

variable "database_port" {
  description = "Port used by the PostgreSQL database."
  type        = number
  default     = 5432
}

variable "alb_ingress_cidrs" {
  description = "CIDR blocks allowed to access the Application Load Balancer."
  type        = list(string)
}

variable "alb_ingress_ports" {
  description = "Ports exposed by the Application Load Balancer."
  type        = list(number)
}

