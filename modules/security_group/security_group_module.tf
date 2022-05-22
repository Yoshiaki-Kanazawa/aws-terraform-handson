resource "aws_security_group" "default" {
  name = var.name
  vpc_id = var.vpc_id

  dynamic "ingress" {
      for_each = var.ingress_rules
      content {
          from_port = ingress.value.port
          to_port = ingress.value.port
          cidr_blocks = ingress.value.cidr_blocks
          security_groups = ingress.value.security_groups
          description = "Allow ${ingress.key}"
          protocol = "tcp"
      }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.name
  }
}