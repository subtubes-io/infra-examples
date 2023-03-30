# terraform import aws_iam_role.lego_movie StepFunctions-MyStateMachine-role-dc2692b9
resource "aws_iam_role" "lego_movie" {

  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "states.amazonaws.com"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )

  force_detach_policies = false
  managed_policy_arns = [
    "arn:aws:iam::568949616117:policy/service-role/LambdaInvokeScopedAccessPolicy-e1b034d6-1239-4d0a-ac52-174bc84b7b44",
    "arn:aws:iam::568949616117:policy/service-role/XRayAccessPolicy-20888a76-b4de-49f1-bbdd-6cf099d24cfd",
  ]
  max_session_duration = 3600
  name                 = "StepFunctions-MyStateMachine-role-dc2692b9"
  path                 = "/service-role/"
  tags                 = {}
  tags_all             = {}

}


# terraform import aws_sfn_state_machine.lego_movie arn:aws:states:us-west-2:568949616117:stateMachine:GetRandomQuote
resource "aws_sfn_state_machine" "lego_movie" {

  definition = jsonencode(
    {
      Comment = "A description of my state machine"
      StartAt = "Lambda Invoke"
      States = {
        "Add Author Lambda" = {
          End        = true
          OutputPath = "$.Payload"
          Parameters = {
            FunctionName = "arn:aws:lambda:us-west-2:568949616117:function:addAuthor:$LATEST"
            "Payload.$"  = "$"
          }
          Resource = "arn:aws:states:::lambda:invoke"
          Retry = [
            {
              BackoffRate = 2
              ErrorEquals = [
                "Lambda.ServiceException",
                "Lambda.AWSLambdaException",
                "Lambda.SdkClientException",
                "Lambda.TooManyRequestsException",
              ]
              IntervalSeconds = 2
              MaxAttempts     = 6
            },
          ]
          Type = "Task"
        }
        "Lambda Invoke" = {
          Next       = "Pass"
          OutputPath = "$.Payload"
          Parameters = {
            FunctionName = "arn:aws:lambda:us-west-2:568949616117:function:showRandomQuote:$LATEST"
            "Payload.$"  = "$"
          }
          Resource = "arn:aws:states:::lambda:invoke"
          Retry = [
            {
              BackoffRate = 2
              ErrorEquals = [
                "Lambda.ServiceException",
                "Lambda.AWSLambdaException",
                "Lambda.SdkClientException",
                "Lambda.TooManyRequestsException",
              ]
              IntervalSeconds = 2
              MaxAttempts     = 6
            },
          ]
          Type = "Task"
        }
        Pass = {
          Next = "Wait"
          Type = "Pass"
        }
        Wait = {
          Next        = "Add Author Lambda"
          SecondsPath = "$.body.waitSeconds"
          Type        = "Wait"
        }
      }
    }
  )

  name     = "GetRandomQuote"
  role_arn = aws_iam_role.lego_movie.arn
  tags     = {}
  tags_all = {}
  type     = "STANDARD"

  logging_configuration {
    include_execution_data = false
    level                  = "OFF"
  }

  tracing_configuration {
    enabled = false
  }
}

