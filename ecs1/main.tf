resource "aws_cloudwatch_log_group" "ecs" {
  name              = var.APP_NAME
  retention_in_days = var.LOG_RETENTATION_IN_DAYS
}


resource "aws_security_group" "alb" {
  name        = "ecs_loadbalancer_security_group"
  description = "Security Group for Loadbalancer"
  vpc_id      = var.VPC_ID

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Port 80 ingress"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Port 443 ingress"
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "egress"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}

resource "aws_security_group" "ecs" {
  name        = "ecs_security_group"
  description = "Security Group for Loadbalancer"
  vpc_id      = var.VPC_ID

  ingress {
    security_groups = [aws_security_group.alb.id]
    description     = "port ingress"
    from_port       = 5000
    protocol        = "tcp"
    to_port         = 5000
  }



  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "egress"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}


resource "aws_lb" "app" {
  name               = "${var.APP_NAME}-alb"
  internal           = var.APPLICATION_IS_INTERNAL
  load_balancer_type = "network"
  # security_groups    = [aws_security_group.alb.id]
  subnets = var.LB_SUBNETS
}

resource "aws_lb_target_group" "gateway" {
  name        = "${var.APP_NAME}-app-one-tg"
  port        = 9000
  protocol    = "TCP"
  vpc_id      = var.VPC_ID
  target_type = "ip"
}


resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.gateway.arn
  }
}



resource "aws_ecs_cluster" "this" {
  name = var.APP_NAME
  setting {
    name  = "containerInsights"
    value = var.CONTAINER_INSIGHTS ? "enabled" : "disable"
  }

  tags = {
    "Name" = var.APP_NAME
  }
}