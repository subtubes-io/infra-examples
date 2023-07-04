resource "aws_cloudfront_function" "webapp" {
  name    = "${var.env}-webapp-redirect"
  runtime = "cloudfront-js-1.0"
  comment = "redirect cloudfront.net to custom domain"
  publish = true
  code = templatefile("./function.js", {
    fqdn = var.fqdn,
  })
}


// terraform import aws_cloudfront_function.webapp dev-webapp-redirect
