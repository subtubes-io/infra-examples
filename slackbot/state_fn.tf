# terraform import aws_iam_role.example_state_machine StepFunctions-MyStateMachine-role-74de1883
resource "aws_iam_role" "example_state_machine" {
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
    "arn:aws:iam::568949616117:policy/service-role/XRayAccessPolicy-4ef4d576-8dbc-4080-a6e8-87d69def4def",
  ]
  max_session_duration = 3600
  name                 = "StepFunctions-MyStateMachine-role-74de1883"
  path                 = "/service-role/"
  tags                 = {}
  tags_all             = {}
}


# terraform import aws_sfn_state_machine.example_state_machine arn:aws:states:us-west-2:568949616117:stateMachine:MyStateMachine
resource "aws_sfn_state_machine" "example_state_machine" {
  name     = "MyStateMachine"
  role_arn = aws_iam_role.example_state_machine.arn
  definition = jsonencode(
    {
      Comment = "A description of my state machine"
      StartAt = "Pass"
      States = {
        "Add to Known Folder" = {
          Next = "Read Message"
          Type = "Pass"
        }
        "Check Message Content" = {
          Next = "Is Spam Choice ?"
          Type = "Pass"
        }
        "Default Choice" = {
          End  = true
          Type = "Pass"
        }
        "Default State" = {
          End  = true
          Type = "Pass"
        }
        "Delete Message" = {
          End  = true
          Type = "Pass"
        }
        "Is In Contact List?" = {
          Choices = [
            {
              BooleanEquals = false
              Next          = "Check Message Content"
              Variable      = "$.inContactList"
            },
            {
              BooleanEquals = true
              Next          = "Add to Known Folder"
              Variable      = "$.inContactList"
            },
          ]
          Default = "Default State"
          Type    = "Choice"
        }
        "Is Spam Choice ?" = {
          Choices = [
            {
              BooleanEquals = true
              Next          = "Delete Message"
              Variable      = "$.isSpam"
            },
            {
              BooleanEquals = false
              Next          = "Review Message"
              Variable      = "$.isSpam"
            },
          ]
          Default = "Default Choice"
          Type    = "Choice"
        }
        Pass = {
          Next = "Is In Contact List?"
          Type = "Pass"
        }
        "Read Message" = {
          End  = true
          Type = "Pass"
        }
        "Review Message" = {
          Next = "Wait For Reading Message"
          Type = "Pass"
        }
        "Wait For Reading Message" = {
          End         = true
          SecondsPath = "$.waitTime"
          Type        = "Wait"
        }
      }
    }
  )
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

