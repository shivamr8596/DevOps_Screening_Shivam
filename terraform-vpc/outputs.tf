output "vpc_id" {
  description = "ID of VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "ID of public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_id" {
  description = "ID of private subnets"
  value       = aws_subnet.private[*].id
}

output "route_table_id" {
  description = "ID of the secondary routing table"
  value       = aws_route_table.public.id
}

output "ec2_instance_public_ip" {
  description = "Public IP of the EC2 instance created."
  value       = aws_instance.windows_machine.public_ip
}
