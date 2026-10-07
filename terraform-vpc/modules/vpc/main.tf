resource "aws_vpc" "main" {
  cidr_block = var.aws_vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "vpc"
    Environment = "Development"
    Project     = "DevOps Screening"
  }
}

resource "aws_subnet" "public" {
  count  = length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.main.id

  cidr_block = element(var.public_subnet_cidrs, count.index)

  availability_zone = element(var.vpc_availability_zones, count.index)

  tags = {
    Name        = "Public Subnet ${count.index + 1}"
    Environment = "Development"
    Project     = "DevOps Screening"
  }
}

resource "aws_subnet" "private" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id

  cidr_block = element(var.private_subnet_cidrs, count.index)

  availability_zone = element(var.vpc_availability_zones, count.index)

  tags = {
    Name        = "Private Subnet ${count.index + 1}"
    Environment = "Development"
    Project     = "DevOps Screening"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "internet-gateway"
    Environment = "Development"
    Project     = "DevOps Screening"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "Route Table"
    Environment = "Development"
    Project     = "DevOps Screening"
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id = aws_route_table.public.id

  destination_cidr_block = var.destination_cidr_block
  gateway_id             = aws_internet_gateway.main.id

}

resource "aws_route_table_association" "public_subnet_asso" {
  count = length(var.public_subnet_cidrs)

  subnet_id = aws_subnet.public[count.index].id

  route_table_id = aws_route_table.public.id
}

resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "Public NACL"
    Environment = "Development"
    Project     = "DevOps Screening"
  }
}

resource "aws_network_acl_rule" "public_inbound_rdp" {
  for_each = var.allowed_ips

  network_acl_id = aws_network_acl.public.id

  rule_number = 100 + index(
    sort(tolist(var.allowed_ips)),
    each.value
  )

  egress      = false
  protocol    = "tcp"
  rule_action = "allow"

  cidr_block = each.value

  from_port = 3389
  to_port   = 3389
}

resource "aws_network_acl_rule" "public_inbound_ephemeral" {
  network_acl_id = aws_network_acl.public.id

  rule_number = 200
  egress      = false
  protocol    = "tcp"
  rule_action = "allow"

  cidr_block = "0.0.0.0/0"

  from_port = 1024
  to_port   = 65535
}


resource "aws_network_acl_rule" "public_outbound" {
  network_acl_id = aws_network_acl.public.id

  rule_number = 100
  egress      = true

  protocol    = "-1"
  rule_action = "allow"

  cidr_block = "0.0.0.0/0"
}


resource "aws_network_acl_association" "public" {
  count = length(var.public_subnet_cidrs)

  network_acl_id = aws_network_acl.public.id
  subnet_id      = aws_subnet.public[count.index].id
}
