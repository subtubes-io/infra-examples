resource "aws_ecr_repository" "api_subtubes" {
    image_tag_mutability = "MUTABLE" #"IMMUTABLE"
    name                 = "slackbot-secops"
    tags                 = {}
    tags_all             = {}

    # encryption_configuration {
    #     encryption_type = "KMS"
    #     kms_key         = "arn:aws:kms:us-west-2:568949616117:key/997312a1-1c42-4962-aef7-03df2856c5e3"
    # }

    image_scanning_configuration {
        scan_on_push = false
    }

    timeouts {}
}