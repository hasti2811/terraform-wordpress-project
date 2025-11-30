output "domain_name" {
  value = var.domain_name
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}
