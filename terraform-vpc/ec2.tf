module "ec2" {
  source = "./modules/ec2"

  instances = {
    application = {
      ami           = data.aws_ami.windows.id
      instance_type = var.ec2_instance_type
      name          = "application-server"

      subnet_id = module.vpc.private_subnet_ids[0]

      security_group_id = module.security_groups.ec2_security_group_id

      associate_public_ip_address = false

      key_name = aws_key_pair.ec2_kp.key_name

      iam_instance_profile = aws_iam_instance_profile.ec2_ssm.name

      root_block_device = {
        volume_size           = var.ec2_root_volume_size
        volume_type           = var.ec2_root_volume_type
        iops                  = var.ec2_root_volume_iops
        throughput            = var.ec2_root_volume_throughput
        encrypted             = true
        delete_on_termination = true
      }
    }
  }

  tags = {
    Environment = "Development"
    Project     = "DevOps Screening"
  }
}
