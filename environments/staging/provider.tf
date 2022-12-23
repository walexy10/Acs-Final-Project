# AWS Provider

provider "aws" {
  region = var.region
}


terraform {
  backend "s3" {
    bucket = "osaliu3finalproject3"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}