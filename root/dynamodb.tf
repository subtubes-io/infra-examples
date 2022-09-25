
# Create the DyanmoDB table
resource "aws_dynamodb_table" "tf_state_lock" {
  name         = "TerraformStateLock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "dynamodb-tf-state-lock"
    ManagedBy = "terraform"
  }
}