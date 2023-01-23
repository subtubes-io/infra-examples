data "aws_ssm_parameter" "slack_signing_secret" {
  name = "prod.secops.lambda.secrets"
}


resource "aws_lambda_function" "slackbot_secops" {

  architectures = [
    "x86_64",
  ]

  environment {
    variables = {
      "SLACK_SIGNING_SECRET" = data.aws_ssm_parameter.slack_signing_secret.value
    }
  }

  function_name = "slackbot-secops"
  image_uri     = "568949616117.dkr.ecr.us-west-2.amazonaws.com/slackbot-secops@sha256:5cbac8a682f66805c48dc1cffe29f49bc986e22ccd26ba869dacb6f89c282aaf"
  memory_size   = 128
  package_type  = "Image"
  role          = "arn:aws:iam::568949616117:role/slackbot_lambda_role"
  tags          = {}
  tags_all      = {}

  ephemeral_storage {
    size = 512
  }

  timeouts {}

  tracing_config {
    mode = "PassThrough"
  }

  lifecycle {
    ignore_changes = [
      image_uri,
      environment[0].variables["SLACK_SIGNING_SECRET"],
    ]
  }

}

# terraform import aws_lambda_function.slackbot_secops slackbot-secops
# terraform state show aws_lambda_function.slackbot_secops 
