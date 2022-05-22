########### ECR ###########
resource "aws_ecr_repository" "backend" {
  name                 = "handson-backend"
  image_tag_mutability = "IMMUTABLE"

  encryption_configuration {
    encryption_type = "KMS"
  }
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "backend_policy" {
  repository = aws_ecr_repository.backend.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 30 images",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 30
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF

  depends_on      = [
    aws_ecr_repository.backend
  ]
}

resource "aws_ecr_repository" "frontend" {
  name                 = "handson-frontend"
  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "KMS"
  }
  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository" "base" {
  name                 = "handson-base"
  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "KMS"
  }
  image_scanning_configuration {
    scan_on_push = false
  }
}

########### VPC endpoint ###########
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.ap-northeast-1.ecr.api"
  vpc_endpoint_type = "Interface"

  subnet_ids = [
    module.subnet_private_egress_1a.subnet_id,
    module.subnet_private_egress_1c.subnet_id
  ]

  security_group_ids = [
    module.sg_vpce.sg_id
  ]

  private_dns_enabled = true

  tags = {
    Name = "handson-vpce-ecr-api"
  }
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.ap-northeast-1.ecr.dkr"
  vpc_endpoint_type = "Interface"

  subnet_ids = [
    module.subnet_private_egress_1a.subnet_id,
    module.subnet_private_egress_1c.subnet_id
  ]

  security_group_ids = [
    module.sg_vpce.sg_id
  ]

  private_dns_enabled = true

  tags = {
    Name = "handson-vpce-ecr-dkr"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.ap-northeast-1.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table.rt_app.id
  ]

  tags = {
    Name = "handson-vpce-s3"
  }
}

resource "aws_vpc_endpoint" "cloudwatch_logs" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.ap-northeast-1.logs"
  vpc_endpoint_type = "Interface"

  subnet_ids = [
    module.subnet_private_egress_1a.subnet_id,
    module.subnet_private_egress_1c.subnet_id
  ]

  security_group_ids = [
    module.sg_vpce.sg_id
  ]

  private_dns_enabled = true

  tags = {
    Name = "handson-vpce-logs"
  }
}

resource "aws_vpc_endpoint" "secrets_manager" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.ap-northeast-1.secretsmanager"
  vpc_endpoint_type = "Interface"

  subnet_ids = [
    module.subnet_private_egress_1a.subnet_id,
    module.subnet_private_egress_1c.subnet_id
  ]

  security_group_ids = [
    module.sg_vpce.sg_id
  ]

  private_dns_enabled = true

  tags = {
    Name = "handson-vpce-secretsmanager"
  }
}

########### IAM Role for ECS ###########
data "aws_iam_policy_document" "ecs_task_execution_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "secretsmanager:GetSecretValue"
    ]
    resources = ["*"]
  }
}

module "ecs_task_execution_role" {
  source = "../../modules/iam_role"
  name = "ecsTaskExecutionRole"
  identifier = "ecs-tasks.amazonaws.com"
  policy = data.aws_iam_policy_document.ecs_task_execution_policy.json
}

########### Cloudwatch Log Group ###########
resource "aws_cloudwatch_log_group" "backend_log_group" {
  name = "/ecs/handson-backend-def"
  retention_in_days = 3
}

resource "aws_cloudwatch_log_group" "frontend_log_group" {
  name = "/ecs/handson-frontend-def"
  retention_in_days = 3
}

########### ECS ###########
resource "aws_ecs_task_definition" "ecs_backend_task_def" {
  family = "handson-backend-def"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = module.ecs_task_execution_role.iam_role_arn
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "app",
    "image": "[AWS_ACCOUNT_ID].dkr.ecr.ap-northeast-1.amazonaws.com/handson-backend:v1",
    "cpu": 256,
    "memory": 512,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "protocol": "tcp"
      }
    ],
    "readonlyRootFilesystem": true,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "ap-northeast-1",
        "awslogs-stream-prefix": "ecs",
        "awslogs-group": "/ecs/handson-backend-def"
      }
    },
    "secrets": [
      {
        "name": "DB_HOST",
        "valueFrom": "arn:aws:secretsmanager:ap-northeast-1:[AWS_ACCOUNT_ID]:secret:handson/mysql-kBeeZI:host::"
      },
      {
        "name": "DB_NAME",
        "valueFrom": "arn:aws:secretsmanager:ap-northeast-1:[AWS_ACCOUNT_ID]:secret:handson/mysql-kBeeZI:dbname::"
      },
      {
        "name": "DB_USERNAME",
        "valueFrom": "arn:aws:secretsmanager:ap-northeast-1:[AWS_ACCOUNT_ID]:secret:handson/mysql-kBeeZI:username::"
      },
      {
        "name": "DB_PASSWORD",
        "valueFrom": "arn:aws:secretsmanager:ap-northeast-1:[AWS_ACCOUNT_ID]:secret:handson/mysql-kBeeZI:password::"
      }
    ]
  }
]
TASK_DEFINITION

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

resource "aws_ecs_cluster" "ecs_backend_cluster" {
  name = "handson-ecs-backend-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_service" "ecs_backend_service" {
  name            = "handson-ecs-backend-service"
  cluster         = aws_ecs_cluster.ecs_backend_cluster.id
  task_definition = aws_ecs_task_definition.ecs_backend_task_def.arn
  launch_type     = "FARGATE"
  desired_count   = 2
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  enable_ecs_managed_tags = true

  network_configuration {
    subnets = [
      module.subnet_private_container_1a.subnet_id,
      module.subnet_private_container_1c.subnet_id,
    ]
    security_groups = [
      module.sg_backend.sg_id
    ]
    assign_public_ip = false
  }

  health_check_grace_period_seconds = 120

  load_balancer {
    target_group_arn = aws_lb_target_group.internal_tg_blue.arn
    container_name   = "app"
    container_port   = 80
  }

  service_registries {
    registry_arn = aws_service_discovery_service.ecs_service_discovery.arn
  }

  lifecycle {
    ignore_changes = [
      load_balancer,
      desired_count,
      task_definition,
    ]
  }

  depends_on      = [
    module.ecs_code_deploy_role,
    aws_ecs_cluster.ecs_backend_cluster,
    aws_ecs_task_definition.ecs_backend_task_def,
    aws_service_discovery_service.ecs_service_discovery
  ]
}

resource "aws_ecs_task_definition" "ecs_frontend_task_def" {
  family = "handson-frontend-def"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = module.ecs_task_execution_role.iam_role_arn
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "app",
    "image": "[AWS_ACCOUNT_ID].dkr.ecr.ap-northeast-1.amazonaws.com/handson-frontend:dbv1",
    "cpu": 256,
    "memory": 512,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "protocol": "tcp"
      }
    ],
    "readonlyRootFilesystem": true,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "ap-northeast-1",
        "awslogs-stream-prefix": "ecs",
        "awslogs-group": "/ecs/handson-frontend-def"
      }
    },
    "environment": [
      {
        "name": "SESSION_SECRET_KEY",
        "value": "41b678c65b37bf99c37bcab522802760"
      },
      {
        "name": "APP_SERVICE_HOST",
        "value": "http://internal-handson-alb-internal-2058812079.ap-northeast-1.elb.amazonaws.com"
      },
      {
        "name": "NOTIF_SERVICE_HOST",
        "value": "http://internal-handson-alb-internal-2058812079.ap-northeast-1.elb.amazonaws.com"
      }
    ],
    "secrets": [
      {
        "name": "DB_HOST",
        "valueFrom": "arn:aws:secretsmanager:ap-northeast-1:[AWS_ACCOUNT_ID]:secret:handson/mysql-kBeeZI:host::"
      },
      {
        "name": "DB_NAME",
        "valueFrom": "arn:aws:secretsmanager:ap-northeast-1:[AWS_ACCOUNT_ID]:secret:handson/mysql-kBeeZI:dbname::"
      },
      {
        "name": "DB_USERNAME",
        "valueFrom": "arn:aws:secretsmanager:ap-northeast-1:[AWS_ACCOUNT_ID]:secret:handson/mysql-kBeeZI:username::"
      },
      {
        "name": "DB_PASSWORD",
        "valueFrom": "arn:aws:secretsmanager:ap-northeast-1:[AWS_ACCOUNT_ID]:secret:handson/mysql-kBeeZI:password::"
      }
    ]
  }
]
TASK_DEFINITION

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

resource "aws_ecs_cluster" "ecs_frontend_cluster" {
  name = "handson-ecs-frontend-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_service" "ecs_frontend_service" {
  name            = "handson-ecs-frontend-service"
  cluster         = aws_ecs_cluster.ecs_frontend_cluster.id
  task_definition = aws_ecs_task_definition.ecs_frontend_task_def.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  deployment_controller {
    type = "ECS"
  }

  enable_ecs_managed_tags = true

  network_configuration {
    subnets = [
      module.subnet_private_container_1a.subnet_id,
      module.subnet_private_container_1c.subnet_id,
    ]
    security_groups = [
      module.sg_frontend.sg_id
    ]
    assign_public_ip = false
  }

  health_check_grace_period_seconds = 120

  load_balancer {
    target_group_arn = aws_lb_target_group.ingress_tg.arn
    container_name   = "app"
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition,
    ]
  }

  depends_on = [
    aws_ecs_cluster.ecs_frontend_cluster,
    aws_ecs_task_definition.ecs_frontend_task_def
  ]
}