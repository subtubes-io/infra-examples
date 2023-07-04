

resource "aws_route53_record" "app_record" {
  zone_id = var.hosted_zone_id
  name    = var.fqdn
  type    = "A"
  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.cdn_bucket.domain_name
    zone_id                = aws_cloudfront_distribution.cdn_bucket.hosted_zone_id

  }

}

