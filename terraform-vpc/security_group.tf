resource "aws_security_group" "rdp" {
  name        = "rdp-security-group"
  description = "Allow RDP only from fixed IP."
  vpc_id      = aws_vpc.main.id

  tags = {
    Name        = "rdp-security-group"
    Environment = "Development"
    Project     = "DevOps Screening"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ips" {
  for_each = {
    for rule in local.ingress_rules_flat :
    "${rule.description}-${rule.cidr_ipv4}" => rule
  }

  security_group_id = aws_security_group.rdp.id

  description = each.value.description
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocol
  cidr_ipv4   = each.value.cidr_ipv4
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {

  for_each = {
    for idx, rule in local.egress_rules_flat :
    "${idx}-${rule.cidr_ipv4}" => rule
  }

  security_group_id = aws_security_group.rdp.id

  description = each.value.description
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocol
  cidr_ipv4   = each.value.cidr_ipv4
}
