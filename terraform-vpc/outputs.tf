output "ec2_instance_public_ip" {
  description = "Public IP of the EC2 instance created."
  value       = module.ec2.public_ip
}

output "ec2_instance_public_dns" {
  description = "Public DNS of the EC2 instance created."
  value       = module.ec2.public_dns
}
