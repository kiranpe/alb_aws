################
#ALBListener
################

resource "aws_lb_listener" "alb_listener" {
  count = var.create_lb ? length(var.https_listeners) : 0

  load_balancer_arn = aws_lb.alb[0].arn
  port              = var.http_listeners[count.index]["port"]
  protocol          = lookup(var.http_listeners[count.index], "protocol", "HTTPS")
#  certificate_arn   = var.https_listeners[count.index]["certificate_arn"]
#  ssl_policy        = lookup(var.https_listeners[count.index], "ssl_policy", var.listener_ssl_policy_default)


  default_action {
    target_group_arn = aws_lb_target_group.alb_target_group[0].arn
    type             = "forward"
  }
}

##################################################
#ECSNginxListenerRule && ECSNginxIDMListenerRule
##################################################

resource "aws_lb_listener_rule" "PrivateECSALBAPIMStoreListenerRule" {
  count = var.create_lb && length(var.rule1) > 0 ? length(var.rule1) : 0

  listener_arn = aws_lb_listener.alb_listener[0].arn
  priority     = lookup(var.rule1[count.index], "priority", null)

  action {
    type             = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.alb_target_group[0].id 
        weight = 1
      }
     target_group {
      arn = aws_lb_target_group.alb_target_group[1].id
      weight   = 1
     }
    }
  }

  condition {
    path_pattern {
      values = ["/store"]
    }
  }

  depends_on = [aws_lb_target_group.alb_target_group]
}

resource "aws_lb_listener_rule" "PrivateECSALBAPIMPublisherListenerRule" {
  count = var.create_lb && length(var.rule2) > 0 ? length(var.rule2) : 0

  listener_arn = aws_lb_listener.alb_listener[0].arn
  priority     = lookup(var.rule2[count.index], "priority", null)

  action {
    type             = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.alb_target_group[0].id
        weight = 1
      }
     target_group {
      arn = aws_lb_target_group.alb_target_group[1].id
      weight   = 1
     }
    }
  }

  condition {
    path_pattern {
      values = ["/publisher"]
    }
  }

  depends_on = [aws_lb_target_group.alb_target_group]
}

resource "aws_lb_listener_rule" "PrivateECSALBGWWListenerRule" {
  count = var.create_lb && length(var.rule3) > 0 ? length(var.rule3) : 0

  listener_arn = aws_lb_listener.alb_listener[0].arn
  priority     = lookup(var.rule3[count.index], "priority", null)

  action {
    type             = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.alb_target_group[2].id
        weight = 1
      }
     target_group {
        arn = aws_lb_target_group.alb_target_group[8].id
        weight   = 1
     }
    }
  }

#Replace with GatewayWorkerHostname

  condition {
    host_header {
      values = ["example.com"]
    }
  }

  depends_on = [aws_lb_target_group.alb_target_group]
}

resource "aws_lb_listener_rule" "PrivateECSALBGWMListenerRule" {
  count = var.create_lb && length(var.rule4) > 0 ? length(var.rule4) : 0

  listener_arn = aws_lb_listener.alb_listener[0].arn
  priority     = lookup(var.rule4[count.index], "priority", null)

  action {
    type             = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.alb_target_group[3].id
        weight = 1
      }
     target_group {
        arn = aws_lb_target_group.alb_target_group[9].id
        weight   = 1
     }
    }
  }

#Replace with GatewayManagerHostname

  condition {
    host_header {
      values = ["example.com"]
    }
  }

  depends_on = [aws_lb_target_group.alb_target_group]
}

resource "aws_lb_listener_rule" "PrivateECSALBIDMListenerRule" {
  count = var.create_lb && length(var.rule5) > 0 ? length(var.rule5) : 0

  listener_arn = aws_lb_listener.alb_listener[0].arn
  priority     = lookup(var.rule5[count.index], "priority", null)

  action {
    type             = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.alb_target_group[4].id
        weight = 1
      }
     target_group {
        arn = aws_lb_target_group.alb_target_group[10].id
        weight   = 1
     }
    }
  }

#Replace with IDMHostname

  condition {
    host_header {
      values = ["example.com"]
    }
  }

  depends_on = [aws_lb_target_group.alb_target_group]
}

resource "aws_lb_listener_rule" "PrivateECSALBTMListenerRule" {
  count = var.create_lb && length(var.rule6) > 0 ? length(var.rule6) : 0

  listener_arn = aws_lb_listener.alb_listener[0].arn
  priority     = lookup(var.rule6[count.index], "priority", null)

  action {
    type             = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.alb_target_group[5].id
        weight = 1
      }
     target_group {
        arn = aws_lb_target_group.alb_target_group[11].id
        weight   = 1
     }
    }
  }

#Replace with TrafficManagerHostname

  condition {
    host_header {
      values = ["example.com"]
    }
  }

  depends_on = [aws_lb_target_group.alb_target_group]
}

resource "aws_lb_listener_rule" "PrivateECSALBBPSListenerRule" {
  count = var.create_lb && length(var.rule7) > 0 ? length(var.rule7) : 0

  listener_arn = aws_lb_listener.alb_listener[0].arn
  priority     = lookup(var.rule7[count.index], "priority", null)

  action {
    type             = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.alb_target_group[6].id
        weight = 1
      }
     target_group {
        arn = aws_lb_target_group.alb_target_group[12].id
        weight   = 1
     }
    }
  }

#Replace with BPSHostname

  condition {
    host_header {
      values = ["example.com"]
    }
  }

  depends_on = [aws_lb_target_group.alb_target_group]
}
 
resource "aws_lb_listener_rule" "PrivateECSALBAnalyticsListenerRule" {
  count = var.create_lb && length(var.rule8) > 0 ? length(var.rule8) : 0

  listener_arn = aws_lb_listener.alb_listener[0].arn
  priority     = lookup(var.rule8[count.index], "priority", null)

  action {
    type             = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.alb_target_group[7].id
        weight = 1
      }
     target_group {
        arn = aws_lb_target_group.alb_target_group[13].id
        weight   = 1
     }
    }
  }

#Replace with AnalyticsHostname

  condition {
    host_header {
      values = ["example.com"]
    }
  }

  depends_on = [aws_lb_target_group.alb_target_group]
}
