resource "tls_private_key" "rdp_kp" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "rdp_kp" {
  key_name   = "rdp_kp"
  public_key = tls_private_key.rdp_kp.public_key_openssh
}

resource "aws_secretsmanager_secret" "private_key" {
  name        = "ec2-private-key-11"
  description = "Private SSH key for EC2 instances"
}

resource "aws_secretsmanager_secret_version" "private_key_val" {
  secret_id     = aws_secretsmanager_secret.private_key.id
  secret_string = tls_private_key.rdp_kp.private_key_pem
}
