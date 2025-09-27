resource "aws_dynamodb_table" "terraform_locks" {
  name         = "staging-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  hash_key = "LockID"
  tags = {
    Name = "terraform-locks"
    ManagedBy = "Terraform"
  }
}
