data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket  = "subtubes-rezflow-tf-state"
    key     = "development/vpc/terraform.tfstate"
    encrypt = "true"
    region  = "us-west-2"
  }
}
