resource "aws_ecs_task_definition" "api" {
  container_definitions    = jsonencode(
        [
            {
                cpu              = 0
                environment      = []
                essential        = true
                image            = "568949616117.dkr.ecr.us-west-2.amazonaws.com/simple-http:091b7ad"
                logConfiguration = {
                    logDriver = "awslogs"
                    options   = {
                        awslogs-group         = "/ecs/simple-http"
                        awslogs-region        = "us-west-2"
                        awslogs-stream-prefix = "ecs"
                    }
                }
                mountPoints      = []
                name             = "simple-http"
                portMappings     = [
                    {
                        containerPort = 8000
                        hostPort      = 0
                        protocol      = "tcp"
                    },
                ]
                volumesFrom      = []
            },
        ]
    )
    cpu                      = "256"
    execution_role_arn       = "arn:aws:iam::568949616117:role/ecsTaskExecutionRole"
    family                   = "simple-http"
    #id                       = "simple-http"
    memory                   = "512"
    network_mode             = "bridge"
    requires_compatibilities = [
        "EC2",
    ]
    #revision                 = 32
    tags                     = {}
    tags_all                 = {}
    task_role_arn            = "arn:aws:iam::568949616117:role/simple-http-task"

}

# terraform import aws_ecs_task_definition.api   arn:aws:ecs:us-west-2:568949616117:task-definition/simple-http:32 