resource "aws_ecs_task_definition" "api_subtubes" {
  container_definitions = jsonencode(
    [
      {
        cpu         = 128
        environment = []
        essential   = true
        image       = "568949616117.dkr.ecr.us-west-2.amazonaws.com/subtubes-api:latest"
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = "/ecs/api-subtubes"
            awslogs-region        = "us-west-2"
            awslogs-stream-prefix = "ecs"
          }
        }
        memoryReservation = 128
        mountPoints       = []
        name              = "api-subtubes"
        portMappings = [
          {
            containerPort = 6060
            hostPort      = 6060
            protocol      = "tcp"
          },
        ]
        volumesFrom = []
      },
    ]
  )
  cpu                = "256"
  execution_role_arn = aws_iam_role.task_execution.arn
  family             = "api-subtubes"

  memory             = "512"
  network_mode       = "awsvpc"
  requires_compatibilities = [
    "FARGATE",
  ]
  
  tags          = {}
  tags_all      = {}
  task_role_arn = "arn:aws:iam::568949616117:role/api-subtubes-task-role"

  runtime_platform {
    operating_system_family = "LINUX"
  }
}
