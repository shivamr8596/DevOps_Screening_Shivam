resource "aws_db_subnet_group" "isolated_db_subnet_group" {
  name        = var.subnet_group_name
  description = "Database subnet group restricted to isolated private subnets"
  subnet_ids  = var.private_subnet_ids

  tags = merge(var.tags, {
    Name = var.subnet_group_name
  })
}

resource "aws_db_instance" "db_instance" {
  identifier = var.identifier

  engine         = var.engine
  engine_version = var.engine_version

  instance_class = var.instance_class

  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type

  publicly_accessible = var.publicly_accessible

  db_name  = var.db_name
  username = var.username
  password = var.password

  db_subnet_group_name = aws_db_subnet_group.isolated_db_subnet_group.name

  vpc_security_group_ids = [
    var.security_group_id
  ]

  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot
  deletion_protection     = var.deletion_protection
  multi_az                = var.multi_az

  tags = merge(var.tags, {
    Name = var.name
  })
}

