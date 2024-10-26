resource "aws_codebuild_project" "tf-plan" {
  name          = "tf-cicd-plan2"
  description   = "Plan stage for terraform"
  service_role  = "arn:aws:iam::060795916438:role/CodeBuildServiceRole"
  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
 }
 source {
     type   = "CODEPIPELINE"
     buildspec = file("buildspec/plan-buildspec.yml")
 }
}

resource "aws_codebuild_project" "tf-apply" {
  name          = "tf-cicd-apply"
  description   = "Apply stage for terraform"
  service_role  = "arn:aws:iam::060795916438:role/CodeBuildServiceRole"

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
 }
 
 source {
     type   = "CODEPIPELINE"
     buildspec = file("buildspec/apply-buildspec.yml")
 }

}



resource "aws_codepipeline" "cicd_pipeline" {

    name = "tf-cicd"
    role_arn = "arn:aws:iam::060795916438:role/CodePipelineServiceRole"

    artifact_store {
        type="S3"
        location = aws_s3_bucket.artifacts.id
    }

    stage {
        name = "Source"
        action{
            name = "Source"
            category = "Source"
            owner = "AWS"
            provider = "CodeStarSourceConnection"
            version = "1"
            output_artifacts = ["tf-code"]
            configuration = {
                FullRepositoryId = "Client-HealthCare-North/Website"
                BranchName   = "master"
                ConnectionArn = var.github_connector
                OutputArtifactFormat = "CODE_ZIP"
            }
        }
    }

    stage {
        name ="Plan"
        action{
            name = "Build"
            category = "Build"
            provider = "CodeBuild"
            version = "1"
            owner = "AWS"
            input_artifacts = ["tf-code"]
            configuration = {
                ProjectName = "tf-cicd-plan"
            }
        }
    }

    stage {
        name ="Deploy"
        action{
            name = "Deploy"
            category = "Build"
            provider = "CodeBuild"
            version = "1"
            owner = "AWS"
            input_artifacts = ["tf-code"]
            configuration = {
                ProjectName = "tf-cicd-apply"
            }
        }
    }

}