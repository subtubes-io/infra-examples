resource "aws_acm_certificate" "cert" {
  provider = aws.virginia
  domain_name = "admin.subtubes.io"
  validation_method = "DNS"

  //tags = local.global_tags

  lifecycle {
    create_before_destroy = true
  }
}



resource "aws_route53_record" "cert" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
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

resource "aws_acm_certificate_validation" "cert" {
  provider = aws.virginia
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert : record.fqdn]
  timeouts {
    create = "1m"
  }
}
