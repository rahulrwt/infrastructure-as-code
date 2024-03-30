terraform {
  required_version = ">= 1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  backend "s3" {
      bucket                  = "cooking-corner-terraform-s3"
      key                     = "cooking-corner-state"
      region                  = "ap-south-1"
      # shared_credentials_file = "~/.aws/credentials"
  }
}