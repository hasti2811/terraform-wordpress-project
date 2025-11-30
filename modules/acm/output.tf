output "certificate_arn" {
  value = aws_acm_certificate.my_cert.arn
}

output "certificate_status" {
  value = aws_acm_certificate.my_cert.status
}