output "record_fqdn" {
  value = aws_route53_record.alias_record.fqdn
}

output "hosted_zone" {
  value = data.aws_route53_zone.selected.id
}