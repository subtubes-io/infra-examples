provider "aws" {
  shared_credentials_files = ["~/.aws/credentials"]
  profile                 = "social-standards-west"
}

provider "aws" {
  alias  = "virginia"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                 = "social-standards-east"
  region = "us-east-1"
}
