data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket  = "subtubes-io-tf-state"
    key     = "prod/vpc/terraform.tfstate"
    encrypt = "true"
    region  = "us-west-2"
  }
}
