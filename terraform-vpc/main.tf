resource "aws_vpc" "main" {
  cidr_block = var.aws_vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc"
  }
}

resource "aws_subnet" "public" {
  count  = length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.main.id

  cidr_block = element(var.public_subnet_cidrs, count.index)

  availability_zone = element(var.vpc_availability_zones, count.index)

  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id

  cidr_block = element(var.private_subnet_cidrs, count.index)

  availability_zone = element(var.vpc_availability_zones, count.index)

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "internet-gateway"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "Route Table"
  }
}

resource "aws_route_table_association" "public_subnet_asso" {
  count = length(var.public_subnet_cidrs)

  subnet_id = element(aws_subnet.public[*].id, count.index)

  route_table_id = aws_route_table.rt.id
}
