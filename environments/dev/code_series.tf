########### IAM Role for CodeDeploy ###########
data "aws_iam_policy" "AWSCodeDeployRoleForECS" {
    arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

module "ecs_code_deploy_role" {
  source = "../../modules/iam_role"
  name = "ecsCodeDeployRole"
  identifier = "codedeploy.amazonaws.com"
  policy = data.aws_iam_policy.AWSCodeDeployRoleForECS.policy
}

########### CodeDeploy ###########
resource "aws_codedeploy_app" "codedeploy_app" {
  compute_platform = "ECS"
  name             = "handson-codedeploy-app"
}
resource "aws_codedeploy_deployment_group" "codedeploy_deployment_group" {
  depends_on = [
    aws_ecr_repository.backend,
    aws_ecs_cluster.ecs_backend_cluster,
  ]

  app_name               = aws_codedeploy_app.codedeploy_app.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "handson-codedeploy-deployment-group"
  service_role_arn       = module.ecs_code_deploy_role.iam_role_arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout    = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 0
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.ecs_backend_cluster.name
    service_name = aws_ecs_service.ecs_backend_service.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [
          aws_lb_listener.internal_listener.arn
        ]
      }

      test_traffic_route {
        listener_arns = [
          aws_lb_listener.internal_test_listener.arn
        ]
      }

      target_group {
        name = aws_lb_target_group.internal_tg_blue.name
      }

      target_group {
        name = aws_lb_target_group.internal_tg_green.name
      }
    }
  }
}

########### CodeCommit ###########
resource "aws_codecommit_repository" "default" {
  repository_name = "handson-backend"
  description     = "This is the Handson Backend App Repository"
}

########### IAM Role for CodeBuild ###########
data "aws_iam_policy_document" "codeBuildPolicy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "ecr:ListImages",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
      "codecommit:BatchGet*",
      "codecommit:BatchDescribe*",
      "codecommit:Describe*",
      "codecommit:Get*",
      "codecommit:List*",
      "codecommit:GitPull*",
    ]
    resources = ["*"]
  }
}

module "code_build_role" {
  source = "../../modules/iam_role"
  name = "handsonCodebuildRole"
  identifier = "codebuild.amazonaws.com"
  policy = data.aws_iam_policy_document.codeBuildPolicy.json
}

########### Cloudwatch Log Group ###########
resource "aws_cloudwatch_log_group" "codebuild_log_group" {
  name = "/codebuild/handson-backend-codebuild"
  retention_in_days = 3
}

########### CodeBuild ###########
resource "aws_codebuild_project" "codebuild_app" {
  name          = "handson-backend-codebuild"
  description   = "handson-backend-codebuild"
  build_timeout = "60"
  service_role  = module.code_build_role.iam_role_arn
  badge_enabled = true

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type = "LOCAL"
    modes = [
      "LOCAL_DOCKER_LAYER_CACHE"
    ]
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode = true
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/codebuild/handson-backend-codebuild"
      stream_name = "codebuild"
    }
  }

  source {
    type            = "CODECOMMIT"
    location        = "https://git-codecommit.ap-northeast-1.amazonaws.com/v1/repos/handson-backend"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }
  source_version = "main"

  depends_on      = [
    module.code_build_role,
    aws_cloudwatch_log_group.codebuild_log_group,
    aws_codecommit_repository.default
  ]
}

########### IAM Role for CodePipeline ###########
data "aws_iam_policy_document" "codePipelinePolicy" {
  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject",
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "codedeploy:*",
      "codecommit:BatchGet*",
      "codecommit:BatchDescribe*",
      "codecommit:Describe*",
      "codecommit:Get*",
      "codecommit:List*",
      "codecommit:GitPull*",
      "codecommit:UploadArchive",
      "ecs:RegisterTaskDefinition"
    ]
    resources = ["*"]
  }
}

module "code_pipeline_role" {
  source = "../../modules/iam_role"
  name = "handsonCodePipelineRole"
  identifier = "codepipeline.amazonaws.com"
  policy = data.aws_iam_policy_document.codePipelinePolicy.json
}

########### S3 for Artifacts ###########
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "handson-artifacts-bucket"
}

resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  acl    = "private"
}

########### CodePipeline ###########
resource "aws_codepipeline" "codepipeline_app" {
  name     = "handson-pipeline"
  role_arn = module.code_pipeline_role.iam_role_arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        RepositoryName = aws_codecommit_repository.default.repository_name
        BranchName = "main"
        PollForSourceChanges = false
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.codebuild_app.name
        BatchEnabled = false
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      input_artifacts = ["source_output","build_output"]
      version         = "1"

      configuration = {
        ApplicationName = aws_codedeploy_app.codedeploy_app.name
        DeploymentGroupName = aws_codedeploy_deployment_group.codedeploy_deployment_group.deployment_group_name
        TaskDefinitionTemplateArtifact = "source_output"
        AppSpecTemplateArtifact = "source_output"
        Image1ArtifactName = "build_output"
        Image1ContainerName = "IMAGE1_NAME"
      }
    }
  }

  depends_on      = [
    aws_codecommit_repository.default,
    aws_codebuild_project.codebuild_app,
    aws_codedeploy_app.codedeploy_app,
    aws_s3_bucket.codepipeline_bucket,
    module.code_pipeline_role
  ]
}

########### IAM Role for Trigger ###########
data "aws_iam_policy_document" "trigger" {
  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole",
      "codepipeline:*"
    ]
    resources = ["*"]
  }
}

module "trigger_role" {
  source = "../../modules/iam_role"
  name = "handsonTriggerRole"
  identifier = "cloudwatch.amazonaws.com"
  policy = data.aws_iam_policy_document.trigger.json
}

########### CodePipeline Trigger ###########
resource "aws_cloudwatch_event_rule" "codepipeline_trigger" {
  name        = "handson-codepipeline-trigger"
  description = "Trigger the Handson Code Pipeline."

  event_pattern = <<EOF
{
  "source": [
    "aws.codecommit"
  ],
  "detail-type": [
    "CodeCommit Repository State Change"
  ],
  "resources": [
    "arn:aws:codecommit:ap-northeast-1:[AWS_ACCOUNT_ID]:handson-backend"
  ],
  "detail": {
    "referenceType": [
      "branch"
    ],
    "referenceName": [
      "main"
    ]
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "codepipeline" {
  rule = aws_cloudwatch_event_rule.codepipeline_trigger.name
  role_arn = module.trigger_role.iam_role_arn
  arn = aws_codepipeline.codepipeline_app.arn
}