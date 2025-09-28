output "route53_nameservers" {
  value = aws_route53_zone.primary.name_servers
}

# Output the ARN to use in your listener
output "certificate_arn" {
  value = aws_acm_certificate_validation.https_cert_validation.certificate_arn
}
