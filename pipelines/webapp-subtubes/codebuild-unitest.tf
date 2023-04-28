resource "aws_codebuild_project" "webapp_unittest" {
  badge_enabled      = false
  build_timeout      = 60
  name               = "webapp-unittest"
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
    name                   = "webapp-subtubes-prod-project-unittest"
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
                  - STATIC_FOLDER_NAME=$CODEBUILD_BUILD_NUMBER npm run test
        EOT
    git_clone_depth     = 0
    insecure_ssl        = false
    report_build_status = false
    type                = "CODEPIPELINE"
  }
}