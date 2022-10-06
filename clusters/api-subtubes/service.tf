resource "aws_ecs_service" "api_subtubes" {

  cluster                            = aws_ecs_cluster.subtubes_prod.arn
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  desired_count                      = 2
  enable_ecs_managed_tags            = true
  enable_execute_command             = false
  health_check_grace_period_seconds  = 0
  iam_role                           = "aws-service-role"
  launch_type                        = "FARGATE"
  name                               = "api-subtubes"
  platform_version                   = "LATEST"
  propagate_tags                     = "NONE"
  scheduling_strategy                = "REPLICA"
  tags                               = {}
  tags_all                           = {}
  task_definition                    = aws_ecs_task_definition.api_subtubes.id

  deployment_circuit_breaker {
    enable   = false
    rollback = false
  }

  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    container_name   = "api-subtubes"
    container_port   = 6060
    target_group_arn = "arn:aws:elasticloadbalancing:us-west-2:568949616117:targetgroup/api-subtubes/4bc16afc58d79a60"
  }

  network_configuration {
    assign_public_ip = true
    security_groups = [
      "sg-03534b2bd1efbb691",
    ]
    subnets = [
      "subnet-035d7bc44500bc0e9",
      "subnet-0a30d5f28757aa769",
    ]
  }

  timeouts {}
  lifecycle {
    ignore_changes = [
      task_definition
    ]
  }
}
