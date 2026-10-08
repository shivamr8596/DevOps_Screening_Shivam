module "alb" {
  source = "./modules/lb"

  name = "application-alb"

  vpc_id = module.vpc.vpc_id

  subnet_ids = module.vpc.public_subnet_ids

  security_group_id = module.security_groups.alb_security_group_id

  access_logs_bucket_id = module.s3.bucket_id

  enable_access_logs = true

  lb_logs_prefix = "alb-logs"

  lb_listener_port     = 80
  lb_listener_protocol = "HTTP"

  default_target_group_name = "application"

  target_groups = [
    {
      name        = "application"
      port        = var.application_port
      protocol    = "HTTP"
      target_type = "instance"

      health_check = {
        enabled  = true
        path     = "/"
        protocol = "HTTP"
        port     = "traffic-port"
      }
    }
  ]

  attachments = {
    application = {
      target_group_name = "application"
      target_id         = module.ec2.instance_ids["application"]
      port              = var.application_port
    }
  }

  tags = {
    Environment = "Development"
    Project     = "DevOps Screening"
  }
}
