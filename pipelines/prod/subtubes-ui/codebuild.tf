resource "aws_codebuild_project" "app" {
  badge_enabled      = false
  build_timeout      = 60
  name               = var.app_name
  project_visibility = "PRIVATE"
  queued_timeout     = 480
  service_role       = aws_iam_role.code_build.arn
  tags = {
    "stage" = var.env
  }
  tags_all = {
    "stage" = var.env
  }

  artifacts {
    encryption_disabled    = false
    name                   = "${var.app_name}-${var.env}-project"
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
      name  = "VITE_AUTH0_ONBOARD_AUDIENCE"
      type  = "PLAINTEXT"
      value = "prod.api.subtubes.io"
    }


    environment_variable {
      name  = "VITE_APP_FULL_NAME"
      type  = "PLAINTEXT"
      value = "Subtubes"
    }


    environment_variable {
      name  = "VITE_AUTH0_VERIFY_URL"
      type  = "PLAINTEXT"
      value = "https://app.subtubes.io"
    }

    environment_variable {
      name  = "VITE_APP_DEMO"
      type  = "PLAINTEXT"
      value = "Subtubes"
    }



    environment_variable {
      name  = "VITE_ONBOARD_API_URL"
      type  = "PLAINTEXT"
      value = "https://api.subtubes.io"
    }




    environment_variable {
      name  = "VITE_APP_AUTH0_DOMAIN"
      type  = "PLAINTEXT"
      value = "dev-dt8t2igsll5gneka.us.auth0.com"
    }


    environment_variable {
      name  = "VITE_APP_NAME"
      type  = "PLAINTEXT"
      value = "Subtubes"
    }


    environment_variable {
      name  = "VITE_APP_VERSION"
      type  = "PLAINTEXT"
      value = "0.0.1"
    }


    environment_variable {
      name  = "VITE_APP_AUTH0_CLIENT_ID"
      type  = "PLAINTEXT"
      value = "dNeYCx4ynssF8QftjeXAXBSIuYBx1qc4"
    }


    environment_variable {
      name  = "VITE_SSE_API_URL"
      type  = "PLAINTEXT"
          value = "https://sse.subtubes.io"
    }



    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
    type                        = "LINUX_CONTAINER"
  }

  source {
    buildspec = templatefile("./buildspec.yml", {
      bucket_name = var.app_bucket_name,
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
    aws_iam_policy.codebuild_base.arn,
    aws_iam_policy.codebuild_secret_manager.arn,
  ]
  max_session_duration = 3600
  name                 = "${var.app_name}-codebuild-role"
  path                 = "/service-role/"
  tags = {
    "stage"   = var.env
    managedby = "terraform"
  }
  tags_all = {
    "stage"   = var.env
    managedby = "terraform"
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
              "arn:aws:secretsmanager:us-west-2:568949616117:secret:${var.env}/${var.app_name}/*"
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
              "arn:aws:s3:::${var.app_bucket_name}",
              "arn:aws:s3:::${var.app_bucket_name}/*",
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
