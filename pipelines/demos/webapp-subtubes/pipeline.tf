
resource "aws_codestarconnections_connection" "webapp" {
  name          = "webapp-subtubes"
  provider_type = "GitHub"
}


resource "aws_codepipeline" "webapp" {
  name     = "webapp-subtubes-pipeline"
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
        ConnectionArn    = aws_codestarconnections_connection.webapp.arn
        FullRepositoryId = "subtubes-io/subtubes-frontend"
        BranchName       = "beta"
      }
      input_artifacts = []

      output_artifacts = [
        "ReactServerless",
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
        "ProjectName" = aws_codebuild_project.webapp.name
      }
      input_artifacts = [
        "ReactServerless",
      ]
      name = "BuildAction"
      output_artifacts = [
        "ReactServerlessBuild",
      ]
      owner     = "AWS"
      provider  = "CodeBuild"
      run_order = 1
      version   = "1"
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
  managed_policy_arns   = []
  max_session_duration  = 3600
  name                  = "webapp-pipeline"
  path                  = "/"
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
            Resource = aws_codestarconnections_connection.webapp.arn
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

