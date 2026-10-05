resource "aws_security_group" "rdp" {
  name        = "rdp-security-group"
  description = "Allow RDP only from fixed IP."
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.ec2_ingress_rules != null ? var.ec2_ingress_rules : local.ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol

      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.ec2_egress_rules

    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = {
    Name        = "rdp-security-group"
    Environment = "Development"
    Project     = "DevOps Screening"
  }
}
