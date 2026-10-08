resource "tls_private_key" "ec2_kp" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_kp" {
  key_name   = "ec2_kp"
  public_key = tls_private_key.ec2_kp.public_key_openssh
}

resource "aws_secretsmanager_secret" "ec2_private_key" {
  name                    = "ec2-private-key"
  description             = "Private key for EC2 instances"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "ec2_private_key" {
  secret_id     = aws_secretsmanager_secret.ec2_private_key.id
  secret_string = tls_private_key.ec2_kp.private_key_pem
}
