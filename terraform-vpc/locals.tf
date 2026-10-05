locals {
  ingress_rules = var.ec2_ingress_rules != null ? var.ec2_ingress_rules : [
    {
      description = "EC2 instance ingress rules."
      from_port   = 3389
      to_port     = 3389
      protocol    = "tcp"
      cidr_blocks = var.allowed_ips
    }
  ]
}

