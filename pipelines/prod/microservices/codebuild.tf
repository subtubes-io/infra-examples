resource "aws_codebuild_project" "api" {
  badge_enabled      = false
  build_timeout      = 60
  name               = "subtubes-microservices"
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
    name                   = "subtubes-microservices-prod-project"
    override_artifact_name = false
    packaging              = "NONE"
    type                   = "CODEPIPELINE"
  }

  cache {
    modes = []
    type  = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true # so that we can build docker images
    type                        = "LINUX_CONTAINER"
  }

  source {
    buildspec = templatefile("./buildspec.yaml", {
      image_name_fetch = "fetch",
      image_name_gateway = "gateway",
      image_name_sse = "sse",
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
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
  ]
  max_session_duration = 3600
  name                 = "subtubes-microservices-codebuild"
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
