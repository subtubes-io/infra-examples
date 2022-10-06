resource "aws_iam_role" "task_execution" {
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ecs-tasks.amazonaws.com"
          }
          Sid = ""
        },
      ]
      Version = "2008-10-17"
    }
  )

  force_detach_policies = false
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
  ]
  max_session_duration = 3600
  name                 = "ecsTaskExecutionRole"
  path                 = "/"
  tags                 = {}
  tags_all             = {}
}


resource "aws_iam_role" "task_role" {

  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ecs-tasks.amazonaws.com"
          }
          Sid = ""
        },
      ]
      Version = "2012-10-17"
    }
  )

  description           = "Allows ECS tasks to call AWS services on your behalf."
  force_detach_policies = false

  managed_policy_arns  = []
  max_session_duration = 3600
  name                 = "api-subtubes-task-role"
  path                 = "/"
  tags                 = {}
  tags_all             = {}

}
