resource "aws_codebuild_project" "app" {
  badge_enabled      = false
  build_timeout      = 60
  name               = var.app_name
  project_visibility = "PRIVATE"
  queued_timeout     = 480
  service_role       = aws_iam_role.code_build.arn
  tags = {
    "STAGE" = "prod"
  }
  tags_all = {
    "STAGE" = "prod"
  }

  artifacts {
    encryption_disabled    = false
    name                   = "${var.app_name}-prod-project"
    override_artifact_name = false
    packaging              = "NONE"
    type                   = "CODEPIPELINE"
  }

  cache {
    modes = []
    type  = "NO_CACHE"
  }

  environment {

    environment_variable {
      name  = "REACT_APP_AUTH0_DOMAIN"
      type  = "PLAINTEXT"
      value = "subtubes-dev.auth0.com"
    }

    # environment_variable {
    #   name  = "REACT_APP_AUTH0_CLIENT_ID"
    #   type  = "SECRETS_MANAGER"
    #   value = "prod/webapp-subtubes-io/REACT_APP_AUTH0_CLIENT_ID"
    # }

    # environment_variable {
    #   name  = "REACT_APP_AUTH0_CLIENT_ID"
    #   type  = "PLAINTEXT"
    #   value = "fxoHKeCsOJ5IHPC4IJr7Mm9giazzozis"
    # }
    # environment_variable {
    #   name  = "REACT_APP_AUTH0_CALLBACK_URL"
    #   type  = "PLAINTEXT"
    #   value = "https://app.subtubes.io/callback"
    # }
    # environment_variable {
    #   name  = "REACT_APP_API_SERVER_URL"
    #   type  = "PLAINTEXT"
    #   value = "https://api.subtubes.io"
    # }
    # environment_variable {
    #   name  = "REACT_APP_AUTH0_AUDIENCE"
    #   type  = "PLAINTEXT"
    #   value = "https://backend.subtubes.io"
    # }

    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
    type                        = "LINUX_CONTAINER"
  }

  source {
    buildspec = templatefile("./buildspec.yml", {
      bucket_name = "subtubes-io-admin-app", 
    })
    git_clone_depth     = 0
    insecure_ssl        = false
    report_build_status = false
    type                = "CODEPIPELINE"
  }
}

resource "aws_iam_role" "code_build" {

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

  force_detach_policies = false

  managed_policy_arns = [
    "arn:aws:iam::568949616117:policy/service-role/CodeBuildBasePolicy-webapp-us-west-2",
    "arn:aws:iam::568949616117:policy/service-role/CodeBuildSecretsManagerPolicy-webapp-us-west-2",
  ]
  max_session_duration = 3600
  name                 = "admin-app-subtubes-codebuild"
  path                 = "/service-role/"
  tags = {
    "STAGE" = "prod"
  }
  tags_all = {
    "STAGE" = "prod"
  }

  inline_policy {
    name = "root"
    policy = jsonencode(
      {
        Statement = [
          {
            Action = [
              "secretsmanager:GetSecretValue"
            ]
            Effect = "Allow"
            Resource = [
              #"arn:aws:secretsmanager:us-west-2:568949616117:secret:prod/webapp-subtubes-io/REACT_APP_AUTH0_CLIENT_ID-EjQO52"
              "arn:aws:secretsmanager:us-west-2:568949616117:secret:prod/webapp-subtubes-io/*"
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
              "s3:GetObject",
              "s3:GetObjectVersion",
              "s3:GetBucketVersioning",
              "s3:PutObject",
              "s3:PutObjectAcl",
            ]
            Effect = "Allow"
            Resource = [
              "arn:aws:s3:::subtubes-io-admin-app",
              "arn:aws:s3:::subtubes-io-admin-app/*",
            ]
          },
          {
            Action = [
              "logs:CreateLogGroup",
              "logs:CreateLogStream",
              "logs:PutLogEvents",
              "cloudfront:CreateInvalidation",
            ]
            Effect = "Allow"
            Resource = [
              "*",
            ]
          },
        ]
        Version = "2012-10-17"
      }
    )
  }
}
