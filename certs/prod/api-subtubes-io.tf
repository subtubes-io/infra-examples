resource "aws_acm_certificate" "api_subtubes_io" {
  domain_name = "api.subtubes.io"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "api_subtubes_io" {
  for_each = {
    for dvo in aws_acm_certificate.api_subtubes_io.domain_validation_options : dvo.domain_name => {
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
  zone_id         = "Z3VGYF890VO9CP"
}

resource "aws_acm_certificate_validation" "api_subtubes_io" {
  certificate_arn         = aws_acm_certificate.api_subtubes_io.arn
  validation_record_fqdns = [for record in aws_route53_record.api_subtubes_io : record.fqdn]
  timeouts {
    create = "1m"
  }
}
