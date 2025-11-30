output "rds_endpoint" {
  value = aws_db_instance.rds_instance.endpoint
}

output "rds_port" {
  value = aws_db_instance.rds_instance.port
}

output "db_name" {
  value = var.db_name
}

output "db_username" {
  value = var.db_username
}

output "db_password" {
  value = var.db_password
}

