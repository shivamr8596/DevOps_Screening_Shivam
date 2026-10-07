resource "aws_instance" "windows_machine" {
  ami           = data.aws_ami.windows.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.public[0].id

  vpc_security_group_ids = [aws_security_group.rdp.id]

  associate_public_ip_address = true

  key_name = aws_key_pair.rdp_kp.key_name

  root_block_device {
    volume_size           = 40
    volume_type           = "gp3"
    iops                  = 6000
    throughput            = 250
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name        = "Windows-RDP"
    Environment = "Development"
    Project     = "DevOps Screening"
  }
}
