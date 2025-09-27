
resource "aws_lb" "app_lb" {
    name               = var.prefix != "" ? "${var.prefix}-${var.lb_name}" : var.lb_name
    internal           = false
    load_balancer_type = "application"
    security_groups    = var.lb_sg_ids
    subnets            = var.lb_subnet_ids

    enable_deletion_protection = false
}

    # resource "aws_lb_target_group" "blue_tg" {
    #     name     = "blue-target-group"
    #     port     = 8080
    #     protocol = "HTTP"
    #     vpc_id   = var.vpc_id
    #     health_check {
    #         interval            = 30
    #         path                = "/"
    #         timeout             = 5
    #         healthy_threshold   = 5
    #         unhealthy_threshold = 2
    #         matcher             = "200"
    #     }
    # }

    resource "aws_lb_target_group" "green_tg" {
        name     = "green-target-group"
        port     = 8080
        protocol = "HTTP"
        vpc_id   = var.vpc_id
        deregistration_delay = 60

        health_check {
            interval            = 10
            path                = "/healthcheck"
            timeout             = 5
            healthy_threshold   = 2
            unhealthy_threshold = 2
            matcher             = "200"
            port = 8080
        }
    }

resource "aws_lb_listener" "app_listener" {
    load_balancer_arn = aws_lb.app_lb.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.green_tg.arn
    }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08" #Or a more recent policy.
  certificate_arn   = var.certificate_arn # ARN of your SSL certificate

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green_tg.arn
  }
}

resource "aws_autoscaling_attachment" "asg_target_group_attachment" {
  autoscaling_group_name = var.asg_id
  lb_target_group_arn    = aws_lb_target_group.green_tg.arn
}