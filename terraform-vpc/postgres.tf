module "postgres" {
  source = "./modules/db"

  subnet_group_name = "isolated-db-subnet-group"

  private_subnet_ids = module.vpc.private_subnet_ids

  security_group_id = module.security_groups.rds_security_group_id

  identifier = "devops-screening-postgres"

  engine         = "postgres"
  engine_version = var.postgres_engine_version

  instance_class = "db.t3.micro"

  allocated_storage = var.postgres_allocated_storage
  storage_type      = "gp3"

  publicly_accessible = false

  db_name  = var.postgres_db_name
  username = var.postgres_username
  password = var.postgres_password

  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false
  multi_az                = false

  name = "PostgreSQL Database"

  tags = {
    Environment = "Development"
    Project     = "DevOps Screening"
  }
}

