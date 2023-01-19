
# Create the DyanmoDB table
resource "aws_dynamodb_table" "slackbot" {
  name         = "slackbot"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "uuid"

  attribute {
    name = "uuid"
    type = "S"
  }

  # attribute {
  #   name = "message"
  #   type = "S"
  # }


  tags = {
    Name      = "dynamodb-tf-state-lock"
    ManagedBy = "terraform"
  }
}
