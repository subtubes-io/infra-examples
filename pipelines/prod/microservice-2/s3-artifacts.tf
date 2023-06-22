resource "aws_s3_bucket" "artifacts" {
  bucket              = var.pipeline_bucket_name
  object_lock_enabled = false
  tags = {
    "STAGE" = var.env
  }
  tags_all = {
    "STAGE" = var.env
  }
}

resource "aws_s3_bucket_versioning" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id
  versioning_configuration {
    status = "Disabled"
    #mfa_delete = "Disabled"
  }
}

resource "aws_s3_bucket_request_payment_configuration" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id
  payer  = "BucketOwner"
}