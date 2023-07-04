provider "aws" {
  shared_credentials_files = ["~/.aws/credentials"]
  profile                 = "subtubes"
}

provider "aws" {
  alias  = "virginia"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                 = "subtubes"
  region = "us-east-1"
}
