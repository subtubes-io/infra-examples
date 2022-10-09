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
    target_group_arn = aws_lb_target_group.api_subtubes.arn
  }

  network_configuration {
    assign_public_ip = true
    security_groups = [
      aws_security_group.prod_api_subtubes_service.id
    ]
    subnets = data.terraform_remote_state.vpc.outputs.prod_main_public_subnets_ids
  }

  timeouts {}
  lifecycle {
    ignore_changes = [
      task_definition
    ]
  }
}
