resource "aws_dynamodb_table" "terraform_state" {
  name           = "rahul-terraform-state-lock"
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
      region                  = "us-east-1"
    #   dynamodb_table          = "rahul-terraform-state-lock"  #Once the terraform_state dynamodb table is created, uncomment this
  }
}
