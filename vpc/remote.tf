provider "aws" {
  region = "us-west-2"
  shared_credentials_files = ["/Users/edgarmartinez/.aws/credentials"]
  profile = "default"
}

terraform {
  required_version = "~> 1.4.5"

  backend "s3" {
    bucket         = "subtubes-io-tf-state"
    key            = "prod/vpc/terraform.tfstate"
    encrypt        = "true"
    region         = "us-west-2"
    dynamodb_table = "TerraformStateLock"
  }
}

