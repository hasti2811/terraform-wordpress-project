terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.22.1"
    }
  }

  backend "s3" {
    bucket = "terraform-wordpress-hasti"
    key = "terraform.tfstate"
    region = "eu-west-2"
    dynamodb_table = "terraform-wordpress-lock"
  }
}

provider "aws" {
  region = "eu-west-2"
}