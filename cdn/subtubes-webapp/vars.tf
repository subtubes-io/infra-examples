variable "s3_bucket_name" {
  type        = string
  default     = ""
  description = "Bucket name for S3 bucket for CDN"
}

variable "cf_origin_name" {
  type        = string
  default     = ""
  description = "Cloudfront origin name "
}