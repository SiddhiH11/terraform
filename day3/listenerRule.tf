resource "aws_lb" "application_load_balancer" {
  name               = "${var.project}-${var.env}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.security_group.id]

  subnets = data.aws_subnets.default_subnets.ids
}
resource "aws_lb_listener" "application_load_balancer_listener" {
    load_balancer_arn = aws_lb.application_load_balancer.arn
    port = 80
    protocol = "HTTP"
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.home_target_group.arn
    }
}

resource "aws_lb_listener_rule" "laptop_listener_rule" {
    listener_arn = aws_lb_listener.application_load_balancer_listener.arn
    priority = 100  
    action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.laptop_target_group.arn
    }

  condition {
    path_pattern {
      values = ["/laptop/*"]
    }
  }
}

resource "aws_lb_listener_rule" "mobile_listener_rule" {
    listener_arn = aws_lb_listener.application_load_balancer_listener.arn
    priority = 100  
    action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.mobile_target_group.arn
    }

  condition {
    path_pattern {
      values = ["/mobile/*"]
    }
  }
}