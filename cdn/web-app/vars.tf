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
variable "fqdn" {
  type = string
  description = "Flly qualified domain name for CDN"
}

variable "hosted_zone_id" {
  type = string
  description = "AWS hosted zone ID"
}

variable "env" {
  type = string
  description = "Environment"
}