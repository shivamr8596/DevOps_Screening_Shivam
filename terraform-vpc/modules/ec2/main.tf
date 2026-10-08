resource "aws_instance" "instance" {
  for_each = var.instances

  ami           = each.value.ami
  instance_type = each.value.instance_type

  subnet_id = each.value.subnet_id

  vpc_security_group_ids = [
    each.value.security_group_id
  ]

  associate_public_ip_address = each.value.associate_public_ip_address

  key_name = each.value.key_name

  iam_instance_profile = each.value.iam_instance_profile

  root_block_device {
    volume_size           = each.value.root_block_device.volume_size
    volume_type           = each.value.root_block_device.volume_type
    iops                  = each.value.root_block_device.iops
    throughput            = each.value.root_block_device.throughput
    encrypted             = each.value.root_block_device.encrypted
    delete_on_termination = each.value.root_block_device.delete_on_termination
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = merge(var.tags, {
    Name = each.value.name
  })
}

