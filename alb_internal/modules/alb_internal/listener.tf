################
#ALBListener
################

resource "aws_lb_listener" "alb_listener" {
  count = var.create_lb ? length(var.http_listeners) : 0

  load_balancer_arn = aws_lb.alb[0].arn
  port              = var.http_listeners[count.index]["port"]
  protocol          = lookup(var.http_listeners[count.index], "protocol", "HTTPS")

  default_action {
    target_group_arn = aws_lb_target_group.alb_target_group[0].arn
    type             = "forward"
  }
}

##################################################
#ECSNginxListenerRule && ECSNginxIDMListenerRule
##################################################

resource "aws_lb_listener_rule" "listener_rule1" {
  count = var.create_lb && length(var.rule1) > 0 ? length(var.rule1) : 0

  listener_arn = aws_lb_listener.alb_listener[count.index].arn
  priority     = lookup(var.rule1[count.index], "priority", null)

  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.alb_target_group[0].id
        weight = 1
      }
      target_group {
        arn    = aws_lb_target_group.alb_target_group[1].id
        weight = 0
      }
    }
  }

  condition {
    path_pattern {
      values = ["/index.html"]
    }
  }

  depends_on = [aws_lb_target_group.alb_target_group]
}

resource "aws_lb_listener_rule" "listener_rule2" {
  count = var.create_lb && length(var.rule2) > 0 ? length(var.rule2) : 0

  listener_arn = aws_lb_listener.alb_listener[count.index].arn
  priority     = lookup(var.rule2[count.index], "priority", null)

  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.alb_target_group[0].id
        weight = 0
      }
      target_group {
        arn    = aws_lb_target_group.alb_target_group[1].id
        weight = 1
      }
    }
  }

  condition {
    path_pattern {
      values = ["/webapp/login.html"]
    }
  }

  depends_on = [aws_lb_target_group.alb_target_group]
}
