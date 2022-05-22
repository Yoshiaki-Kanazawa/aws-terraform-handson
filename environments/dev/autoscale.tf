########### IAM Role for Autoscale ###########
data "aws_iam_policy_document" "ecs_autoscale_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ecs:DescribeServices",
      "ecs:UpdateService",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:DeleteAlarms"
    ]
    resources = ["*"]
  }
}

module "ecs_autoscale_role" {
  source = "../../modules/iam_role"
  name = "ecsAutoscaleRole"
  identifier = "application-autoscaling.amazonaws.com"
  policy = data.aws_iam_policy_document.ecs_autoscale_policy.json
}

########### Autoscale for ECS ###########
resource "aws_appautoscaling_target" "ecs_backend_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.ecs_backend_cluster.name}/${aws_ecs_service.ecs_backend_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn           = module.ecs_autoscale_role.iam_role_arn
  min_capacity       = 2
  max_capacity       = 4

  depends_on = [
    module.ecs_autoscale_role,
    aws_ecs_service.ecs_backend_service
  ]
}

resource "aws_appautoscaling_policy" "scaling_policy_with_cpu" {
  name               = "handson-scaleling-policy-with-cpu"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.ecs_backend_cluster.name}/${aws_ecs_service.ecs_backend_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 70
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }

  depends_on = [
    aws_appautoscaling_target.ecs_backend_target
  ]
}