data "aws_iam_policy_document" "codebuild_base" {

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:us-west-2:${var.account_id}:log-group:/aws/codebuild/${var.app_name}",
      "arn:aws:logs:us-west-2:${var.account_id}:log-group:/aws/codebuild/${var.app_name}:*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation"
    ]
    resources = [
      "arn:aws:s3:::codepipeline-us-west-2-*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "codebuild:CreateReportGroup",
      "codebuild:CreateReport",
      "codebuild:UpdateReport",
      "codebuild:BatchPutTestCases",
      "codebuild:BatchPutCodeCoverages"
    ]
    resources = [
      "arn:aws:codebuild:us-west-2:${var.account_id}:report-group/${var.app_name}-*"
    ]
  }
}

resource "aws_iam_policy" "codebuild_base" {
  name   = "${var.app_name}-codebuild-base"
  policy = data.aws_iam_policy_document.codebuild_base.json
  tags = {
    "STAGE"   = var.env
    managedby = "terraform"
  }
  tags_all = {
    "STAGE"   = var.env
    managedby = "terraform"
  }

}




data "aws_iam_policy_document" "codebuild_secret_manager" {

  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
    ]
    resources = [
      "arn:aws:secretsmanager:us-west-2:${var.account_id}:secret:/CodeBuild/*"
    ]
  }

}

resource "aws_iam_policy" "codebuild_secret_manager" {
  name   = "${var.app_name}-codebuild-secret-manager"
  policy = data.aws_iam_policy_document.codebuild_secret_manager.json
  tags = {
    "STAGE"   = var.env
    managedby = "terraform"
  }
  tags_all = {
    "STAGE"   = var.env
    managedby = "terraform"
  }

}
