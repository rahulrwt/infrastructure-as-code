resource "aws_dynamodb_table" "terraform_state" {
  name           = "terraform-state-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  
  attribute {
    name = "LockID"
    type = "S"
  }
}
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
    #   dynamodb_table          = "terrafotrm-state-lock"
      # shared_credentials_file = "~/.aws/credentials"
  }
}
