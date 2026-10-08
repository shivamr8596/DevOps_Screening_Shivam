variable "subnet_group_name" {
  description = "Name of the RDS subnet group."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs used by the RDS subnet group."
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID assigned to the RDS instance."
  type        = string
}

variable "identifier" {
  description = "Unique identifier for the RDS instance."
  type        = string
}

variable "engine" {
  description = "Database engine."
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "PostgreSQL engine version."
  type        = string
}

variable "instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated database storage in GB."
  type        = number
}

variable "storage_type" {
  description = "Storage type used by the RDS instance."
  type        = string
  default     = "gp3"
}

variable "publicly_accessible" {
  description = "Whether the database should have a public endpoint."
  type        = bool
  default     = false
}

variable "db_name" {
  description = "Initial database name."
  type        = string
}

variable "username" {
  description = "Master username for the database."
  type        = string
}

variable "password" {
  description = "Master password for the database."
  type        = string
  sensitive   = true
}

variable "backup_retention_period" {
  description = "Number of days automated backups are retained."
  type        = number
  default     = 0
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot when destroying the database."
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Whether deletion protection is enabled."
  type        = bool
  default     = false
}

variable "multi_az" {
  description = "Whether the database should use Multi-AZ deployment."
  type        = bool
  default     = false
}

variable "name" {
  description = "Name tag for the RDS instance."
  type        = string
}

variable "tags" {
  description = "Common tags applied to RDS resources."
  type        = map(string)
  default     = {}
}

