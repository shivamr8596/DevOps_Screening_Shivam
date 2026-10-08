module "security_groups" {
  source = "./modules/security-groups"

  vpc_id = module.vpc.vpc_id

  application_port = var.application_port
  database_port    = var.database_port

  alb_ingress_cidrs = var.alb_ingress_cidrs
  alb_ingress_ports = var.alb_ingress_ports

  tags = {
    Environment = "Development"
    Project     = "DevOps Screening"
  }
}
