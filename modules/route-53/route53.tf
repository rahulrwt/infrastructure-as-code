# Create a public hosted zone for your domain
resource "aws_route53_zone" "primary" {
  name = var.domain_name     
  comment = "Public hosted zone for your domain"

  tags = {
    Name = "${var.domain_name}-com-zone"
  }
}

# Create the certificate
resource "aws_acm_certificate" "https_cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Name = "${var.domain_name}-certificate"
  }
}

# Create the DNS validation record in Route 53
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.https_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.primary.zone_id
}

# Wait for validation to finish
resource "aws_acm_certificate_validation" "https_cert_validation" {
  certificate_arn         = aws_acm_certificate.https_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
