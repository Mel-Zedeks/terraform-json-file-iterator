# terraform block for version locking
terraform {
  required_version = "~> 1.0"
  required_providers {
    aws={
      source="hashicorp/aws"
      version="~>4.0"
    }
  }
}
# provider block
provider "aws" {
  region = "us-east-1"
#  shared_config_files      = ["/Users/~/.aws/config"]
#  shared_credentials_files = ["/Users/~/.aws/credentials"]
  profile = "default"
}