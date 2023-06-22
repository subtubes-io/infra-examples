
resource "aws_codestarconnections_connection" "api" {
  name          = "subtubes-microservices-backend"
  provider_type = "GitHub"
}


resource "aws_codepipeline" "api" {
  name     = "subtubes-microservices-pipeline"
  role_arn = aws_iam_role.code_pipeline.arn
  tags = {
    "STAGE" = "prod"
  }
  tags_all = {
    "STAGE" = "prod"
  }

  artifact_store {
    location = aws_s3_bucket.artifacts.id
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.api.arn
        FullRepositoryId = "subtubes-io/subtubes-backend"
        BranchName       = "master"
      }
      input_artifacts = []

      output_artifacts = [
        "subtubes-microservices-prod-project",
      ]

      run_order = 1
      version   = "1"

      name     = "Source"
      category = "Source"
      owner    = "AWS"
      provider = "CodeStarSourceConnection"

    }
  }
  stage {
    name = "Build"

    action {
      category = "Build"
      configuration = {
        "ProjectName" = aws_codebuild_project.api.name
      }
      input_artifacts = [
        "subtubes-microservices-prod-project",
      ]
      name = "BuildAction"
      output_artifacts = [
        "subtubes-microservices-prod-project-build",
      ]
      owner     = "AWS"
      provider  = "CodeBuild"
      run_order = 1
      version   = "1"
    }
  }



  stage {
    name = "Deploy"
    action {
      category = "Deploy"
      configuration = {
        "ClusterName" = "subtubes-prod"
        "FileName"    = "imagedefinitions.json"
        "ServiceName" = "subtubes-microservices"
      }
      input_artifacts = [
        "subtubes-microservices-prod-project-build",
      ]
      name             = "ECSDeployment"
      output_artifacts = []
      owner            = "AWS"
      provider         = "ECS"
      region           = "us-west-2"
      run_order        = 1
      version          = "1"
    }
  }
}


resource "aws_iam_role" "code_pipeline" {
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
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS",
  ]
  max_session_duration = 3600
  name                 = "subtubes-microservices-pipeline"
  path                 = "/"
  tags = {
    "STAGE" = "prod"
  }
  tags_all = {
    "STAGE" = "prod"
  }

  inline_policy {
    name = "codestar"
    policy = jsonencode(
      {
        Statement = [
          {
            Action = [
              "codestar-connections:UseConnection",
            ]
            Effect   = "Allow"
            Resource = aws_codestarconnections_connection.api.arn
          },
          {
            Action = [
              "codestar-connections:*",
            ]
            Effect   = "Allow"
            Resource = aws_codestarconnections_connection.api.arn
          },
          {
            Action = [
              "codebuild:BatchGetBuilds",
              "codebuild:StartBuild",
            ]
            Effect   = "Allow"
            Resource = "*"
          },
        ]
        Version = "2012-10-17"
      }
    )
  }
  inline_policy {
    name = "root"
    policy = jsonencode(
      {
        Statement = [
          {
            Action = [
              "ecs:*",
            ]
            Effect = "Allow"
            Resource = [
              "*",
            ]
          },
          {
            Action = [
              "s3:GetObject",
              "s3:GetObjectVersion",
              "s3:GetBucketVersioning",
              "s3:PutObject",
            ]
            Effect = "Allow"
            Resource = [
              aws_s3_bucket.artifacts.arn,
              "${aws_s3_bucket.artifacts.arn}/*",
            ]
          },
          {
            Action = [
              "codebuild:BatchGetBuilds",
              "codebuild:StartBuild",
            ]
            Effect   = "Allow"
            Resource = "*"
          },
        ]
        Version = "2012-10-17"
      }
    )
  }
}

