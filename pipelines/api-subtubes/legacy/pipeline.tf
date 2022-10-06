resource "aws_codestarconnections_connection" "webapp" {
  name          = "api-subtubes"
  provider_type = "GitHub"
}


resource "aws_codepipeline" "api" {

    name     = "simple-http-blue-greeen"
    role_arn = "arn:aws:iam::568949616117:role/service-role/AWSCodePipelineServiceRole-us-west-2-simplehttp-pipeline"
    tags     = {}
    tags_all = {}

    artifact_store {
        location = "codepipeline-us-west-2-660918935926"
        type     = "S3"
    }

    stage {
        name = "Source"

        action {
            category         = "Source"
            configuration    = {
                "BranchName"           = "master"
                "OutputArtifactFormat" = "CODE_ZIP"
                "PollForSourceChanges" = "false"
                "RepositoryName"       = "simplehttp"
            }
            input_artifacts  = []
            name             = "Source"
            namespace        = "SourceVariables"
            output_artifacts = [
                "SourceArtifact",
            ]
            owner            = "AWS"
            provider         = "CodeCommit"
            region           = "us-west-2"
            run_order        = 1
            version          = "1"
        }
    }
    stage {
        name = "Build"

        action {
            category         = "Build"
            configuration    = {
                "ProjectName" = "SimpleHttpCodeBuildV2"
            }
            input_artifacts  = [
                "SourceArtifact",
            ]
            name             = "Build"
            namespace        = "BuildVariables"
            output_artifacts = [
                "DefinitionArtifact",
                "ImageArtifact",
            ]
            owner            = "AWS"
            provider         = "CodeBuild"
            region           = "us-west-2"
            run_order        = 1
            version          = "1"
        }
    }
    stage {
        name = "deploy"

        action {
            category         = "Deploy"
            configuration    = {
                "AppSpecTemplateArtifact"        = "DefinitionArtifact"
                "AppSpecTemplatePath"            = "appspec.yml"
                "ApplicationName"                = "AppECS-ec2-demo-simple-http-blue-green"
                "DeploymentGroupName"            = "ec2-demo-simple-http-blue-green"
                "Image1ArtifactName"             = "ImageArtifact"
                "Image1ContainerName"            = "IMAGE1_NAME"
                "TaskDefinitionTemplateArtifact" = "DefinitionArtifact"
                "TaskDefinitionTemplatePath"     = "taskdef.json"
            }
            input_artifacts  = [
                "DefinitionArtifact",
                "ImageArtifact",
            ]
            name             = "deploy"
            output_artifacts = []
            owner            = "AWS"
            provider         = "CodeDeployToECS"
            region           = "us-west-2"
            run_order        = 1
            version          = "1"
        }
    }

}

#terraform import aws_codepipeline.api simple-http-blue-greeen