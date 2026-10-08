module "ssm" {
  source = "./modules/ssm"

  vpc_id             = module.vpc.vpc_id
  aws_region         = var.aws_region
  private_subnet_ids = module.vpc.private_subnet_ids
  security_group_id  = module.security_groups.ssm_endpoint_security_group_id

  tags = {
    Environment = "Development"
    Project     = "DevOps Screening"
  }
}
