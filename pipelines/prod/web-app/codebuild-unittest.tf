resource "aws_codebuild_project" "app_unitest" {
  badge_enabled      = false
  build_timeout      = 60
  name               = "${var.app_name}-unittest"
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

    # environment_variable {
    #   name  = "REACT_APP_AUTH0_DOMAIN"
    #   type  = "PLAINTEXT"
    #   value = "subtubes-dev.auth0.com"
    # }

    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
    type                        = "LINUX_CONTAINER"
  }

  source {
    buildspec = templatefile("./buildspec-unitest.yml", {
      bucket_name = var.app_bucket_name,
    })
    git_clone_depth     = 0
    insecure_ssl        = false
    report_build_status = false
    type                = "CODEPIPELINE"
  }
}