module "vpc" {
  source = "./modules/vpc"

  aws_vpc_cidr           = var.aws_vpc_cidr
  public_subnet_cidrs    = var.public_subnet_cidrs
  private_subnet_cidrs   = var.private_subnet_cidrs
  vpc_availability_zones = var.vpc_availability_zones
  destination_cidr_block = var.destination_cidr_block
  alb_ingress_ports = var.alb_ingress_ports
  alb_ingress_cidrs = var.alb_ingress_cidrs  
  application_port = var.application_port
  database_port    = var.database_port

  tags = {
    Environment = "Development"
    Project     = "DevOps Screening"
  }
}
