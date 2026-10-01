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

resource "tls_private_key" "rdp_kp" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "rdp_kp" {
  key_name   = "rdp_kp"
  public_key = tls_private_key.rdp_kp.public_key_openssh
}

resource "aws_secretsmanager_secret" "private_key" {
  name        = "ec2-private-key-1"
  description = "Private SSH key for EC2 instances"
}

resource "aws_secretsmanager_secret_version" "private_key_val" {
  secret_id     = aws_secretsmanager_secret.private_key.id
  secret_string = tls_private_key.rdp_kp.private_key_pem
}




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

resource "aws_instance" "windows_machine" {
  ami           = data.aws_ami.windows.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.public[0].id

  vpc_security_group_ids = [aws_security_group.rdp.id]

  associate_public_ip_address = true

  key_name = aws_key_pair.rdp_kp.key_name

  tags = {
    Name        = "Windows-RDP"
    Environment = "Development"
    Project     = "DevOps Screening"
  }
}
