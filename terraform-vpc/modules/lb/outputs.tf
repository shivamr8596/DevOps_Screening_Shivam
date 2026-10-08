output "alb_id" {
  description = "ID of the Application Load Balancer."
  value       = aws_lb.LB.id
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer."
  value       = aws_lb.LB.arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer."
  value       = aws_lb.LB.dns_name
}

output "alb_zone_id" {
  description = "Canonical hosted zone ID of the Application Load Balancer."
  value       = aws_lb.LB.zone_id
}

output "target_group_arns" {
  description = "ARNs of the ALB target groups."
  value = {
    for name, target_group in aws_lb_target_group.target_group :
    name => target_group.arn
  }
}

output "listener_arn" {
  description = "ARN of the ALB listener."
  value       = aws_lb_listener.listener.arn
}

