resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "main"
  subnet_ids = [var.private_subnet_1, var.private_subnet_2]
}

resource "aws_db_instance" "rds_instance" {
  engine                    = "mysql"
  engine_version            = "8.0"
  skip_final_snapshot       = true
  final_snapshot_identifier = "my-final-snapshot"
  instance_class            = "db.t3.micro"
  allocated_storage         = 20
  identifier                = "my-rds-instance"
  db_name                   = var.db_name
  username                  = var.db_username
  password                  = var.db_password
  db_subnet_group_name      = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids    = [var.rds_sg_id]
}