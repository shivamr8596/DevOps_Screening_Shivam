module "s3" {
  source = "./modules/s3"

  name = "devops-screening-alb-logs"

  force_destroy = true

  logs_prefix = "alb-logs"

  tags = {
    Environment = "Development"
    Project     = "DevOps Screening"
  }
}
