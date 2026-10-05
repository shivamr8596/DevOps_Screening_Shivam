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
