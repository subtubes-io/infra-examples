variable "pipeline_bucket_name" {
  type        = string
  description = "S3 pipleine artifacts bucket name"
}
variable "app_name" {
  type        = string
  description = "value for the app"
}
variable "app_bucket_name" {
  type        = string
  description = "Bucket that web app is deployed to"
}

variable "env" {
  type        = string
  description = "App Environment"
}

variable "account_id" {
  type        = string
  description = "AWS account ID"
}
