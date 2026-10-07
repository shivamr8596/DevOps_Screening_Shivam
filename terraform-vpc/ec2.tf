module "ec2" {
  source = "./modules/ec2"

  instances = {
    for name, instance in var.instances : name => {
      ami = data.aws_ami.windows.id

      instance_type = instance.instance_type
      name          = instance.name

      subnet_id = module.vpc.public_subnet_ids[0]

      security_group_id = aws_security_group.rdp.id

      associate_public_ip_address = instance.associate_public_ip_address

      key_name = aws_key_pair.rdp_kp.key_name

      root_block_device = instance.root_block_device
    }
  }
}
