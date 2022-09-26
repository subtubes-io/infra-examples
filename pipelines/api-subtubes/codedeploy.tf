resource "aws_codedeploy_app" "app" {
  compute_platform = "ECS"
  name             = "AppECS-ec2-demo-simple-http-blue-green"
  # tags             = {}
  # tags_all         = {}
}

resource "aws_codedeploy_deployment_config" "app" {
  compute_platform = "ECS"
  //deployment_config_id   = "960fab0e-8fd6-4803-b4f9-be3cf3d3ca45"
  deployment_config_name = "custom.10percent.5minutes.canary"
  //    id                     = "custom.10percent.5minutes.canary"

  traffic_routing_config {
    type = "TimeBasedCanary"

    time_based_canary {
      interval   = 5
      percentage = 10
    }
  }
}
