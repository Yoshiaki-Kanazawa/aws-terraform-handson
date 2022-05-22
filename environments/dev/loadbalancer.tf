########### ALB ###########
resource "aws_lb" "internal_alb" {
  name               = "handson-alb-internal"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [module.sg_inner_alb.sg_id]
  subnets            = [
    module.subnet_private_container_1a.subnet_id,
    module.subnet_private_container_1c.subnet_id
  ]

  tags = {
    Name = "handson-alb-internal"
  }
}

resource "aws_lb" "ingress_alb" {
  name               = "handson-alb-ingress"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.sg_ingress.sg_id]
  subnets            = [
    module.subnet_public_ingress_1a.subnet_id,
    module.subnet_public_ingress_1c.subnet_id
  ]

  tags = {
    Name = "handson-alb-ingress"
  }
}

########### ALB target group ###########
resource "aws_lb_target_group" "internal_tg_blue" {
  name     = "handson-internal-tg-blue"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    healthy_threshold = 3
    interval = 15
    matcher = 200
    path = "/healthcheck"
    timeout = 5
    unhealthy_threshold = 2
  }

  depends_on = [
    aws_lb.internal_alb
  ]
}

resource "aws_lb_target_group" "internal_tg_green" {
  name     = "handson-internal-tg-green"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    healthy_threshold = 3
    interval = 15
    matcher = 200
    path = "/healthcheck"
    timeout = 5
    unhealthy_threshold = 2
  }

  depends_on = [
    aws_lb.internal_alb
  ]
}

resource "aws_lb_target_group" "ingress_tg" {
  name     = "handson-ingress-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    healthy_threshold = 3
    interval = 15
    matcher = 200
    path = "/healthcheck"
    timeout = 5
    unhealthy_threshold = 2
  }

  depends_on = [
    aws_lb.ingress_alb
  ]
}

########### ALB listener ###########
resource "aws_lb_listener" "internal_listener" {
  load_balancer_arn = aws_lb.internal_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internal_tg_blue.arn
  }

  lifecycle {
    ignore_changes = [
      default_action
    ]
  }

  depends_on = [
    aws_lb.internal_alb
  ]
}

resource "aws_lb_listener" "internal_test_listener" {
  load_balancer_arn = aws_lb.internal_alb.arn
  port              = "10080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internal_tg_green.arn
  }

  depends_on = [
    aws_lb.internal_alb
  ]
}

resource "aws_lb_listener" "ingress_listener" {
  load_balancer_arn = aws_lb.ingress_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ingress_tg.arn
  }

  depends_on = [
    aws_lb.ingress_alb
  ]
}