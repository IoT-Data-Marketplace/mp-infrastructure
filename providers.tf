terraform {
  required_version = ">= 0.12.24"
}

provider "aws" {
  version    = ">= 2.58.0"
  region     = local.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}