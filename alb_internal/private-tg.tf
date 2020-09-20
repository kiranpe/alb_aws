##########################
#PrivateTG's
##########################

resource "aws_lb_target_group" "alb_target_group" {
  count = var.create_lb && length(var.tg_name) > 0 ? length(var.tg_name) : 0

  name        = lookup(var.target_groups[count.index],"name", null)
  port        = lookup(var.target_groups[count.index],"backend_port", null)
  protocol    = lookup(var.target_groups[count.index], "backend_protocol", null)
  target_type = lookup(var.target_groups[count.index], "target_type", null)

  vpc_id = var.vpc_id

  stickiness {
    type    = "lb_cookie"
    cookie_duration = 10
    enabled = var.target_group_sticky
  }

  dynamic "health_check" {
    for_each = var.health_check
    content {
      interval            = lookup(health_check.value[count.index], "interval", null)
      path                = lookup(health_check.value[count.index], "path", null)
      port                = lookup(health_check.value[count.index], "port", null)
      healthy_threshold   = lookup(health_check.value[count.index], "healthy_threshold", null)
      unhealthy_threshold = lookup(health_check.value[count.index], "unhealthy_threshold", null)
      timeout             = lookup(health_check.value[count.index], "timeout", null)
      protocol            = lookup(health_check.value[count.index], "protocol", null)
      matcher             = lookup(health_check.value[count.index], "matcher", null)
    }
  }

  depends_on = [aws_lb.alb]

  tags = {
    Name               = "${var.StackName}"
    APMID           = "${var.APMID}"
    BillingApprover = "${var.BillingApprover}"
    BusinessSegment = "${var.BusinessSegment}"
    BusinessTower   = "${var.BusinessTower}"
    CreatedBy       = "${var.CreatedBy}"
    Environment        = "${var.Environment}"
    FMC             = "${var.FMC}"
    Service         = "${var.Service}"
    SupportGroup    = "${var.SupportGroup}"
  }
}
