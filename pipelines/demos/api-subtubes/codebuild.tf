resource "aws_codebuild_project" "api" {
  badge_enabled      = false
  build_timeout      = 60
  name               = "api-subtubes"
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
    name                   = "api-subtubes-prod-project"
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
    buildspec           = <<-EOT
            version: 0.2
            phases:
              pre_build:
                commands:
                  - echo Logging in to Amazon ECR...
                  - aws --version
                  - echo $AWS_DEFAULT_REGION
                  - aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 568949616117.dkr.ecr.us-west-2.amazonaws.com
                  - IMAGE_REPO_NAME=subtubes-api
                  - REPOSITORY_URI=568949616117.dkr.ecr.us-west-2.amazonaws.com/$IMAGE_REPO_NAME
                  - COMMIT_HASH=$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-7)
                  - IMAGE_TAG=build-$(echo $CODEBUILD_BUILD_ID | awk -F ":" '{print $2}')
                  - echo List directory files...
                  - ls
                  - echo Installing source NPM dependencies...
                  - npm install
              build:
                commands:
                  - echo Build started on `date`
                  - echo Building the Docker image...
                  - echo Building $REPOSITORY_URI:$IMAGE_TAG 
                  - docker build -t $REPOSITORY_URI:latest .
                  - docker tag $REPOSITORY_URI:latest $REPOSITORY_URI:$IMAGE_TAG
              post_build:
                commands:
                  - echo Build completed on `date`
                  - echo Pushing the docker image ...
                  - docker push $REPOSITORY_URI:$IMAGE_TAG
                  - docker push $REPOSITORY_URI:latest
                  - printf $REPOSITORY_URI:$IMAGE_TAG > imagedefinitions.json
                  - printf '[ { "name":"api-subtubes","imageUri":"%s"}]' $REPOSITORY_URI:$IMAGE_TAG > imagedefinitions.json
                  - cat imagedefinitions.json
            artifacts:
              files:
                - imagedefinitions.json
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
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
  ]
  max_session_duration = 3600
  name                 = "api-subtubes-codebuild"
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
