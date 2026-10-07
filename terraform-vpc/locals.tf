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

  ingress_rules_flat = flatten([
    for rule in local.ingress_rules : [
      for cidr in rule.cidr_blocks : {
        description = rule.description
        from_port   = rule.from_port
        to_port     = rule.to_port
        protocol    = rule.protocol
        cidr_ipv4   = cidr
      }
    ]
  ])
}

locals {
  egress_rules_flat = flatten([
    for rule in var.ec2_egress_rules : [
      for cidr in rule.cidr_blocks : {
        description = rule.description
        from_port   = rule.from_port
        to_port     = rule.to_port
        protocol    = rule.protocol
        cidr_ipv4   = cidr
      }
    ]
  ])
}
