# resource "aws_iam_role" "one" {
#   assume_role_policy = jsonencode(
#     {
#       Statement = [
#         {
#           Action = "sts:AssumeRole"
#           Effect = "Allow"
#           Principal = {
#             Service = "events.amazonaws.com"
#           }
#         },
#       ]
#       Version = "2012-10-17"
#     }
#   )

#   force_detach_policies = false
#   managed_policy_arns   = []
#   max_session_duration  = 3600
#   name                  = "cwe-role-us-west-2-simple-http-blue-greeen"
#   path                  = "/service-role/"
#   tags                  = {}
#   tags_all              = {}

# }


# usedby codesource in pipeline during the sourcinf phase 
resource "aws_iam_role" "code_source" {


  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "codepipeline.amazonaws.com"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )

  force_detach_policies = false

  managed_policy_arns  = []
  max_session_duration = 3600
  name                 = "AWSCodePipelineServiceRole-us-west-2-simplehttp-pipeline"
  path                 = "/service-role/"
  tags                 = {}
  tags_all             = {}

}


resource "aws_iam_role_policy" "code_source" {
  name = "code_source_access_repo"
  role = aws_iam_role.code_source.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "codecommit:GetBranch",
          "codecommit:GetCommit",
          "codecommit:UploadArchive",
          "codecommit:GetUploadArchiveStatus",

        ]
        Effect   = "Allow"
        Resource = "arn:aws:codecommit:us-west-2:568949616117:simplehttp"
      },
      {
        Action = [
          "codedeploy:GetApplication",
          "codedeploy:GetApplicationRevision",
          "codedeploy:RegisterApplicationRevision"
        ]
        Effect   = "Allow"
        Resource = ["arn:aws:codedeploy:us-west-2:568949616117:application:AppECS-ec2-demo-simple-http-blue-green"]
      },
      {
        Action = [
          "codedeploy:CreateDeployment",
          "codedeploy:GetDeployment"
        ]
        Effect   = "Allow"
        Resource = ["arn:aws:codedeploy:us-west-2:568949616117:deploymentgroup:AppECS-ec2-demo-simple-http-blue-green/ec2-demo-simple-http-blue-green"]
      },
      {
        Action = [
          "codedeploy:GetDeploymentConfig"
        ]
        Effect   = "Allow"
        Resource = ["arn:aws:codedeploy:us-west-2:568949616117:deploymentconfig:custom.10percent.5minutes.canary"]
      },
      {
        Action = [
          "s3:*"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::codepipeline-us-west-2-660918935926",
          "arn:aws:s3:::codepipeline-us-west-2-660918935926/*"
        ]
      },
      {
        Action = [
          "ecs:RegisterTaskDefinition"
        ]
        Effect = "Allow"
        Resource = [
          "*"
        ]
      },
      {
        Action = [
          "codebuild:StartBuild",
          "codebuild:BatchGetBuilds"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:codebuild:us-west-2:568949616117:project/SimpleHttpCodeBuildV2"
        ]
      },
      {
        Action = [
          "iam:PassRole"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:iam::568949616117:role/simple-http-task",
          "arn:aws:iam::568949616117:role/ecsTaskExecutionRole"
        ]
      },
    ]
  })

}


# resource "aws_iam_role" "three" {

#   assume_role_policy = jsonencode(
#     {
#       Statement = [
#         {
#           Action = "sts:AssumeRole"
#           Effect = "Allow"
#           Principal = {
#             Service = "events.amazonaws.com"
#           }
#         },
#       ]
#       Version = "2012-10-17"
#     }
#   )

#   force_detach_policies = false

#   managed_policy_arns  = []
#   max_session_duration = 3600
#   name                 = "cwe-role-us-west-2-simple-http-rollling"
#   path                 = "/service-role/"
#   tags                 = {}
#   tags_all             = {}
# }

# resource "aws_iam_role" "four" {

#   assume_role_policy = jsonencode(
#     {
#       Statement = [
#         {
#           Action = "sts:AssumeRole"
#           Effect = "Allow"
#           Principal = {
#             Service = "events.amazonaws.com"
#           }
#         },
#       ]
#       Version = "2012-10-17"
#     }
#   )

#   force_detach_policies = false
#   managed_policy_arns   = []
#   max_session_duration  = 3600
#   name                  = "cwe-role-us-west-2-simplehttp-pipeline"
#   path                  = "/service-role/"
#   tags                  = {}
#   tags_all              = {}

# # }


# resource "aws_iam_role" "five" {

#   assume_role_policy = jsonencode(
#     {
#       Statement = [
#         {
#           Action = "sts:AssumeRole"
#           Effect = "Allow"
#           Principal = {
#             Service = "ec2.amazonaws.com"
#           }
#         },
#       ]
#       Version = "2012-10-17"
#     }
#   )

#   description           = "Allows EC2 instances to call AWS services on your behalf."
#   force_detach_policies = false
#   managed_policy_arns   = []
#   max_session_duration  = 3600
#   name                  = "simple-http-ec2-demo"
#   path                  = "/"
#   tags                  = {}
#   tags_all              = {}

# }

resource "aws_iam_role" "six" {

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

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
  ]
  max_session_duration = 3600
  name                 = "simple-http-task"
  path                 = "/"
  tags                 = {}
  tags_all             = {}

}
resource "aws_iam_role" "seven" {

  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "codebuild.amazonaws.com"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )

  description           = "Allows CodeBuild to call AWS services on your behalf."
  force_detach_policies = false

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser",
  ]
  max_session_duration = 3600
  name                 = "CodeBuildServiceRole"
  path                 = "/"
  tags                 = {}
  tags_all             = {}

}




resource "aws_iam_role_policy" "code_build" {
  name = "code_build"
  role = aws_iam_role.seven.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:logs:us-west-2:568949616117:log-group:simple-http-v2:log-stream:*",
        ]
      },
      {
        Action = [
          "s3:*"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::codepipeline-us-west-2-660918935926",
          "arn:aws:s3:::codepipeline-us-west-2-660918935926/*"
        ]
      },
    ]
  })

}
