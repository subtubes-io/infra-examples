resource "aws_codebuild_project" "api" {
//  arn                    = "arn:aws:codebuild:us-west-2:568949616117:project/SimpleHttpCodeBuildV2"
  badge_enabled          = false
  build_timeout          = 60
  //concurrent_build_limit = 0
  encryption_key         = "arn:aws:kms:us-west-2:568949616117:alias/aws/s3"
 // id                     = "SimpleHttpCodeBuildV2"
  name                   = "SimpleHttpCodeBuildV2"
  project_visibility     = "PRIVATE"
  queued_timeout         = 480
  service_role           = "arn:aws:iam::568949616117:role/CodeBuildServiceRole"
  source_version         = "refs/heads/master"
  tags                   = {}
  tags_all               = {}

  artifacts {
    encryption_disabled    = false
    override_artifact_name = false
    type                   = "NO_ARTIFACTS"
  }

  cache {
    modes = []
    type  = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    type                        = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      group_name = "simple-http-v2"
      status     = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  source {
    git_clone_depth     = 1
    insecure_ssl        = false
    location            = "https://git-codecommit.us-west-2.amazonaws.com/v1/repos/simplehttp"
    report_build_status = false
    type                = "CODECOMMIT"

    git_submodules_config {
      fetch_submodules = false
    }
  }

}
