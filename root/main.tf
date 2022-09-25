resource "aws_s3_bucket" "tf_state" {
  bucket = "subtubes-io-tf-state"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name      = "Terraform Remote State"
    ManagedBy = "terraform"
  }
}

# Enable bucket versioning
resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable bucket server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state_sse" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

