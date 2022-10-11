resource "aws_codebuild_project" "webapp" {
  badge_enabled      = false
  build_timeout      = 60
  name               = "webapp"
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
    name                   = "webapp-subtubes-prod-project"
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

    environment_variable {
      name  = "REACT_APP_AUTH0_CLIENT_ID"
      type  = "PLAINTEXT"
      value = "fxoHKeCsOJ5IHPC4IJr7Mm9giazzozis"
    }
    environment_variable {
      name  = "REACT_APP_AUTH0_CALLBACK_URL"
      type  = "PLAINTEXT"
      value = "https://beta.subtubes.io/callback"
    }
    environment_variable {
      name  = "REACT_APP_API_SERVER_URL"
      type  = "PLAINTEXT"
      value = "https://api.subtubes.io"
    }
    environment_variable {
      name  = "REACT_APP_AUTH0_AUDIENCE"
      type  = "PLAINTEXT"
      value = "https://backend.subtubes.io"
    }

    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
    type                        = "LINUX_CONTAINER"
  }

  source {
    buildspec           = <<-EOT
            version: 0.2
            phases:
              pre_build:
                commands:
                  - echo Change directory...
                  - echo List directory files...
                  - ls
                  - echo Installing source NPM dependencies...
                  - npm install
              build:
                commands:
                  - echo List active directory...
                  - ls
                  - echo Build started on `date`
                  - echo STATIC_FOLDER_NAME=$CODEBUILD_BUILD_NUMBER
                  - STATIC_FOLDER_NAME=$CODEBUILD_BUILD_NUMBER npm run build 
              post_build:
                commands:
                  # copy the contents of /build to S3
                  - aws s3 cp --recursive  ./build s3://subtubes-io-webapp/ 
                  # set the cache-control headers for service-worker.js to prevent
                  # browser caching
                  #- >
                    #aws s3 cp  
                    #--cache-control="max-age=0, no-cache, no-store, must-revalidate" 
                    #./build/service-worker.js s3://subtubes-io-webapp/
                  # set the cache-control headers for index.html to prevent
                  # browser caching
                  - >
                    aws s3 cp  
                    --cache-control="max-age=0, no-cache, no-store, must-revalidate" 
                    ./build/index.html s3://subtubes-io-webapp/
            artifacts:
              files:
                - '**/*'
        EOT
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
  name                 = "webapp-subtubes-codebuild"
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
              "arn:aws:s3:::subtubes-io-webapp",
              "arn:aws:s3:::subtubes-io-webapp/*",
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
