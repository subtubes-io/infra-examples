provider "aws" {
  region = "us-west-2"
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}
