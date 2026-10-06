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
