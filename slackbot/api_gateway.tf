resource "aws_apigatewayv2_api" "slackbot_secops" {
  api_key_selection_expression = "$request.header.x-api-key"
  disable_execute_api_endpoint = false
  name                         = "slackbot-secops"
  protocol_type                = "HTTP"
  route_selection_expression   = "$request.method $request.path"
  tags                         = {}
  tags_all                     = {}
}


# terraform import aws_apigatewayv2_api.slackbot_secops kufzl2ctkg
# terraform state show aws_apigatewayv2_api.slackbot_secops

resource "aws_apigatewayv2_integration" "slackbot_secops_lambda" {
  api_id = aws_apigatewayv2_api.slackbot_secops.id

  connection_type = "INTERNET"
  #   integration_type = "LAMBDA"
  integration_method     = "POST"
  integration_type       = "AWS_PROXY"
  integration_uri        = "arn:aws:lambda:us-west-2:568949616117:function:slackbot-secops"
  payload_format_version = "2.0"
  request_parameters     = {}
  request_templates      = {}
  timeout_milliseconds   = 30000
}

# terraform import aws_apigatewayv2_integration.slackbot_secops_lambda kufzl2ctkg/n6vfzo5
# terraform state show aws_apigatewayv2_integration.slackbot_secops_lambda 

resource "aws_apigatewayv2_route" "slackbot_secops" {
  api_id = aws_apigatewayv2_api.slackbot_secops.id

  api_key_required     = false
  authorization_scopes = []
  authorization_type   = "NONE"
  request_models       = {}
  route_key            = "POST /slackbot-secops"
  target               = "integrations/${aws_apigatewayv2_integration.slackbot_secops_lambda.id}"
}

# terraform import aws_apigatewayv2_route.slackbot_secops kufzl2ctkg/yctso5q
# terraform state show aws_apigatewayv2_route.slackbot_secops


resource "aws_apigatewayv2_stage" "slackbot_secops" {
  api_id = aws_apigatewayv2_api.slackbot_secops.id
  auto_deploy     = true
  name            = "production"
  stage_variables = {}
  tags            = {}
  tags_all        = {}

  default_route_settings {
    data_trace_enabled       = false
    detailed_metrics_enabled = false
    throttling_burst_limit   = 0
    throttling_rate_limit    = 0
  }
}

# terraform import aws_apigatewayv2_stage.slackbot_secops kufzl2ctkg/production
# terraform state show aws_apigatewayv2_stage.slackbot_secops
