provider "aws" {
  region = "us-west-2"
}

terraform {
  required_version = "~> 1.1.0"

  backend "s3" {
    bucket         = "subtubes-io-tf-state"
    key            = "prod/vpc/terraform.tfstate"
    encrypt        = "true"
    region         = "us-west-2"
    dynamodb_table = "TerraformStateLock"
  }
}

