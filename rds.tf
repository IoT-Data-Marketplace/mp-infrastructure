resource "aws_db_subnet_group" "db_subnet_group" {
  name       = format("%s-db-subnet-group", local.cluster_config.cluster_name)
  subnet_ids = module.vpc.public_subnets
}

resource "aws_db_instance" "iot_db" {
  name                 = replace(format("%s-rds-db", local.cluster_config.cluster_name), "-", "_")
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  identifier           = format("%s-rds-db", local.cluster_config.cluster_name)
  vpc_security_group_ids = [
    module.rds_db_sg.security_group_id
  ]
  publicly_accessible = true
  allocated_storage   = 5
  storage_type        = "gp2"
  engine              = "postgres"
  engine_version      = "11.6"
  instance_class      = "db.t2.micro"
  port                = 5432
  username            = "mp_user"
  password            = var.rds_db_password
}