resource "aws_cloudfront_distribution" "cdn_bucket" {
  depends_on = [
    aws_s3_bucket.cdn_bucket,
    aws_cloudfront_origin_access_control.cdn_bucket
  ]
  enabled = true
  aliases = [
    "admin.subtubes.io"
  ]
  origin {
    domain_name         = aws_s3_bucket.cdn_bucket.bucket_regional_domain_name
    connection_attempts = 3
    connection_timeout  = 10

    origin_access_control_id = aws_cloudfront_origin_access_control.cdn_bucket.id
    origin_id                = aws_s3_bucket.cdn_bucket.id
  }

  ordered_cache_behavior {
    // TODO: forwarded_values needs to be validated (something is not right here)
    forwarded_values {
      headers                 = []
      query_string            = true
      query_string_cache_keys = []

      cookies {
        forward           = "none"
        whitelisted_names = []
      }
    }

    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = true
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    path_pattern           = "/index.html"
    smooth_streaming       = false
    target_origin_id       = aws_s3_bucket.cdn_bucket.id
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"
  }
  wait_for_deployment = true
  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  default_cache_behavior {
    allowed_methods = [
      # "DELETE",
      "GET",
      "HEAD",
      "OPTIONS",
      # "PATCH",
      # "POST",
      # "PUT",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = false
    default_ttl            = 86400
    max_ttl                = 31536000
    min_ttl                = 86400
    smooth_streaming       = false
    target_origin_id       = aws_s3_bucket.cdn_bucket.id
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers                 = []
      query_string            = true
      query_string_cache_keys = []

      cookies {
        forward           = "none"
        whitelisted_names = []
      }
    }
  }

  viewer_certificate {
    # cloudfront_default_certificate = true
    # minimum_protocol_version       = "TLSv1"

    acm_certificate_arn            = aws_acm_certificate.cert.arn
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  price_class      = "PriceClass_100"
  retain_on_delete = false
  tags = {
    "STAGE" = "prod"
  }
  tags_all = {
    "STAGE" = "prod"
  }

  default_root_object = "index.html"
  http_version        = "http2"
  is_ipv6_enabled     = true

  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }


  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }

}

resource "aws_cloudfront_origin_access_control" "cdn_bucket" {
  name                              = var.cf_origin_name
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
  description                       = "Managed by Terraform"
}

