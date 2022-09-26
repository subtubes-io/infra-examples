resource "aws_cloudwatch_log_group" "logs" {
  name = "simple-http-v2"

#   tags = {
#     Environment = "production"
#     Application = "serviceA"
#   }
}