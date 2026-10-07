terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  required_version = ">= 1.5.0"

}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc/"

  aws_region             = var.aws_region
  aws_vpc_cidr           = var.aws_vpc_cidr
  public_subnet_cidrs    = var.public_subnet_cidrs
  private_subnet_cidrs   = var.private_subnet_cidrs
  vpc_availability_zones = var.vpc_availability_zones
  destination_cidr_block = var.destination_cidr_block
  allowed_ips            = var.allowed_ips
}
