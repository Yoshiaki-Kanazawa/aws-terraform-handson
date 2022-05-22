<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.1.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.13.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.13.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_code_build_role"></a> [code\_build\_role](#module\_code\_build\_role) | ../../modules/iam_role | n/a |
| <a name="module_code_pipeline_role"></a> [code\_pipeline\_role](#module\_code\_pipeline\_role) | ../../modules/iam_role | n/a |
| <a name="module_ecs_autoscale_role"></a> [ecs\_autoscale\_role](#module\_ecs\_autoscale\_role) | ../../modules/iam_role | n/a |
| <a name="module_ecs_code_deploy_role"></a> [ecs\_code\_deploy\_role](#module\_ecs\_code\_deploy\_role) | ../../modules/iam_role | n/a |
| <a name="module_ecs_task_execution_role"></a> [ecs\_task\_execution\_role](#module\_ecs\_task\_execution\_role) | ../../modules/iam_role | n/a |
| <a name="module_rds_monitoring_role"></a> [rds\_monitoring\_role](#module\_rds\_monitoring\_role) | ../../modules/iam_role | n/a |
| <a name="module_sg_backend"></a> [sg\_backend](#module\_sg\_backend) | ../../modules/security_group | n/a |
| <a name="module_sg_db"></a> [sg\_db](#module\_sg\_db) | ../../modules/security_group | n/a |
| <a name="module_sg_frontend"></a> [sg\_frontend](#module\_sg\_frontend) | ../../modules/security_group | n/a |
| <a name="module_sg_ingress"></a> [sg\_ingress](#module\_sg\_ingress) | ../../modules/security_group | n/a |
| <a name="module_sg_inner_alb"></a> [sg\_inner\_alb](#module\_sg\_inner\_alb) | ../../modules/security_group | n/a |
| <a name="module_sg_management"></a> [sg\_management](#module\_sg\_management) | ../../modules/security_group | n/a |
| <a name="module_sg_vpce"></a> [sg\_vpce](#module\_sg\_vpce) | ../../modules/security_group | n/a |
| <a name="module_subnet_private_container_1a"></a> [subnet\_private\_container\_1a](#module\_subnet\_private\_container\_1a) | ../../modules/subnet | n/a |
| <a name="module_subnet_private_container_1c"></a> [subnet\_private\_container\_1c](#module\_subnet\_private\_container\_1c) | ../../modules/subnet | n/a |
| <a name="module_subnet_private_db_1a"></a> [subnet\_private\_db\_1a](#module\_subnet\_private\_db\_1a) | ../../modules/subnet | n/a |
| <a name="module_subnet_private_db_1c"></a> [subnet\_private\_db\_1c](#module\_subnet\_private\_db\_1c) | ../../modules/subnet | n/a |
| <a name="module_subnet_private_egress_1a"></a> [subnet\_private\_egress\_1a](#module\_subnet\_private\_egress\_1a) | ../../modules/subnet | n/a |
| <a name="module_subnet_private_egress_1c"></a> [subnet\_private\_egress\_1c](#module\_subnet\_private\_egress\_1c) | ../../modules/subnet | n/a |
| <a name="module_subnet_public_ingress_1a"></a> [subnet\_public\_ingress\_1a](#module\_subnet\_public\_ingress\_1a) | ../../modules/subnet | n/a |
| <a name="module_subnet_public_ingress_1c"></a> [subnet\_public\_ingress\_1c](#module\_subnet\_public\_ingress\_1c) | ../../modules/subnet | n/a |
| <a name="module_subnet_public_management_1a"></a> [subnet\_public\_management\_1a](#module\_subnet\_public\_management\_1a) | ../../modules/subnet | n/a |
| <a name="module_subnet_public_management_1c"></a> [subnet\_public\_management\_1c](#module\_subnet\_public\_management\_1c) | ../../modules/subnet | n/a |
| <a name="module_trigger_role"></a> [trigger\_role](#module\_trigger\_role) | ../../modules/iam_role | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.scaling_policy_with_cpu](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.ecs_backend_target](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/appautoscaling_target) | resource |
| [aws_cloudwatch_event_rule.codepipeline_trigger](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.codepipeline](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_log_group.backend_log_group](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.codebuild_log_group](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.frontend_log_group](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_codebuild_project.codebuild_app](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/codebuild_project) | resource |
| [aws_codecommit_repository.default](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/codecommit_repository) | resource |
| [aws_codedeploy_app.codedeploy_app](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/codedeploy_app) | resource |
| [aws_codedeploy_deployment_group.codedeploy_deployment_group](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/codedeploy_deployment_group) | resource |
| [aws_codepipeline.codepipeline_app](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/codepipeline) | resource |
| [aws_db_subnet_group.rds_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/db_subnet_group) | resource |
| [aws_ecr_lifecycle_policy.backend_policy](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.backend](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository.base](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository.frontend](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/ecr_repository) | resource |
| [aws_ecs_cluster.ecs_backend_cluster](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster.ecs_frontend_cluster](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.ecs_backend_service](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/ecs_service) | resource |
| [aws_ecs_service.ecs_frontend_service](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.ecs_backend_task_def](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/ecs_task_definition) | resource |
| [aws_ecs_task_definition.ecs_frontend_task_def](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/ecs_task_definition) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/internet_gateway) | resource |
| [aws_lb.ingress_alb](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/lb) | resource |
| [aws_lb.internal_alb](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/lb) | resource |
| [aws_lb_listener.ingress_listener](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/lb_listener) | resource |
| [aws_lb_listener.internal_listener](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/lb_listener) | resource |
| [aws_lb_listener.internal_test_listener](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.ingress_tg](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.internal_tg_blue](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.internal_tg_green](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/lb_target_group) | resource |
| [aws_rds_cluster.db_cluster](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_instance.db](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/rds_cluster_instance) | resource |
| [aws_route.route_igw](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/route) | resource |
| [aws_route_table.rt_app](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/route_table) | resource |
| [aws_route_table.rt_db](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/route_table) | resource |
| [aws_route_table.rt_public](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/route_table) | resource |
| [aws_route_table_association.rta_app_1a](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.rta_app_1c](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.rta_db_1a](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.rta_db_1c](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.rta_public_ingress_1a](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.rta_public_ingress_1c](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.rta_public_management_1a](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.rta_public_management_1c](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/route_table_association) | resource |
| [aws_s3_bucket.codepipeline_bucket](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.codepipeline_bucket_acl](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/s3_bucket_acl) | resource |
| [aws_service_discovery_private_dns_namespace.internal_namespace](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/service_discovery_private_dns_namespace) | resource |
| [aws_service_discovery_service.ecs_service_discovery](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/service_discovery_service) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/vpc) | resource |
| [aws_vpc_endpoint.cloudwatch_logs](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ecr_api](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ecr_dkr](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.s3](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.secrets_manager](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/vpc_endpoint) | resource |
| [aws_wafv2_web_acl.web_acl_for_ingress_lb](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl_association.association_with_ingress_lb](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/resources/wafv2_web_acl_association) | resource |
| [aws_iam_policy.AWSCodeDeployRoleForECS](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.AmazonRDSEnhancedMonitoringRole](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.codeBuildPolicy](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.codePipelinePolicy](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_autoscale_policy](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_task_execution_policy](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.trigger](https://registry.terraform.io/providers/hashicorp/aws/4.13.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->