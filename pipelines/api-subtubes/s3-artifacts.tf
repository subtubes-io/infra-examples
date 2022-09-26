resource "aws_s3_bucket" "artifacts" {

  bucket = "codepipeline-us-west-2-660918935926"
  hosted_zone_id = "Z3BJ6K6RIION7M"
  object_lock_enabled = false

  #   request_payer       = "BucketOwner"
  tags     = {}
  tags_all = {}
  #   grant {
  #     id = "a804b944fe67af678f6c1f4db565467037b7f578757975ad45871c3ac8892194"
  #     permissions = [
  #       "FULL_CONTROL",
  #     ]
  #     type = "CanonicalUser"
  #   }

  timeouts {}

  #   versioning {
  #     enabled    = false
  #     mfa_delete = false
  #   }
}
