output "db_instance_id" {
  description = "ID of the RDS database instance."
  value       = aws_db_instance.db_instance.id
}

output "db_instance_arn" {
  description = "ARN of the RDS database instance."
  value       = aws_db_instance.db_instance.arn
}

output "db_endpoint" {
  description = "Endpoint of the PostgreSQL database."
  value       = aws_db_instance.db_instance.endpoint
}

output "db_address" {
  description = "Hostname of the PostgreSQL database."
  value       = aws_db_instance.db_instance.address
}

output "db_port" {
  description = "Port used by the PostgreSQL database."
  value       = aws_db_instance.db_instance.port
}

output "db_subnet_group_name" {
  description = "Name of the RDS subnet group."
  value       = aws_db_subnet_group.isolated_db_subnet_group.name
}

