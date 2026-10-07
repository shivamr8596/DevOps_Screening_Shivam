output "public_dns" {
  description = "Public DNS names of the EC2 instances."

  value = {
    for name, instance in aws_instance.instance :
    name => instance.public_dns
  }
}

output "public_ip" {
  description = "Public IP addresses of the EC2 instances."

  value = {
    for name, instance in aws_instance.instance :
    name => instance.public_ip
  }
}

output "instance_ids" {
  description = "IDs of the EC2 instances."

  value = {
    for name, instance in aws_instance.instance :
    name => instance.id
  }
}
