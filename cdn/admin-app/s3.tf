resource "aws_s3_bucket" "cdn_bucket" {
  bucket        = var.s3_bucket_name
  force_destroy = false
  object_lock_enabled = false

  tags = {
    "STAGE" = "prod"
  }
}

resource "aws_s3_bucket_policy" "cdn_bucket" {
  bucket = aws_s3_bucket.cdn_bucket.id
  policy = data.aws_iam_policy_document.cdn_bucket.json
}

data "aws_iam_policy_document" "cdn_bucket" {

  statement {
    sid = "Statement1"
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.cdn_bucket.arn]

    }
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "${aws_s3_bucket.cdn_bucket.arn}/*",
    ]
  }
}
