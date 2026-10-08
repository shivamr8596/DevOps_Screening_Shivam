output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer."
  value       = module.alb.alb_dns_name
}


output "rds_endpoint" {
  description = "Endpoint of the PostgreSQL RDS instance."
  value       = module.postgres.db_endpoint
}


output "rds_address" {
  description = "Hostname of the PostgreSQL RDS instance."
  value       = module.postgres.db_address
}


output "ec2_instance_ids" {
  description = "IDs of the application EC2 instances."
  value       = module.ec2.instance_ids
}
