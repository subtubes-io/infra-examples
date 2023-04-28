provider "aws" {
  region = "us-west-2"
}

terraform {
  required_version = "~> 1.4.5"

  backend "s3" {
    bucket         = "subtubes-io-tf-state"
    key            = "pipelines/prod/admin-app/terraform.tfstate"
    encrypt        = "true"
    region         = "us-west-2"
    dynamodb_table = "TerraformStateLock"
  }
}