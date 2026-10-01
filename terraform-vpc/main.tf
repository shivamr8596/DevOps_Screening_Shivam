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

resource "local_file" "private_key" {
  content         = tls_private_key.rdp_kp.private_key_pem
  filename        = "C:/Users/Windows/.ssh/ECinstance.pem"
  file_permission = "0040"
}

resource "aws_security_group" "rdp" {
  name        = "rdp-security-group"
  description = "Allow RDP only from fixed IP."
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "RDP IP"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"

    cidr_blocks = var.My_IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rdp-security-group"
  }
}

resource "aws_instance" "windows_machine" {
  ami           = data.aws_ami.windows.id
  instance_type = "t3.micro"

  subnet_id = aws_subnet.public[0].id

  vpc_security_group_ids = [aws_security_group.rdp.id]

  associate_public_ip_address = true

  key_name = aws_key_pair.rdp_kp.key_name

  tags = {
    Name = "Windows-RDP"
  }
} 