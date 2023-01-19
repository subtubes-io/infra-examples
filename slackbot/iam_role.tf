resource "aws_iam_role" "slackbot" {
  name = "slackbot_lambda_role"

  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "lambda.amazonaws.com"
          }
          Sid = ""
        },
      ]
      Version = "2012-10-17"
    }
  )

}


resource "aws_iam_role_policy" "slackbot" {
  name = "slackbot_lambda_access_policy"
  role = aws_iam_role.slackbot.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:us-west-2:568949616117:*"
      },
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:us-west-2:568949616117:log-group:/aws/lambda/slackbot:*"
      },
      {
        Action = [
          "Dynamodb:*"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:us-west-2:568949616117:log-group:/aws/lambda/slackbot:*"
      },
    ]
  })

}
