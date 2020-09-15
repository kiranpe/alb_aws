####################
#ALBSecurityGroup
####################

resource "aws_security_group" "alb_ingress" {
  name   = "alb_ingress"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.ports

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/8"]
      description = "ALB Security Group"
    }
  }
}

###################
#AppLoadBalancer
###################

resource "aws_lb" "alb" {
  count = var.create_lb ? 1 : 0

  name               = var.name
  load_balancer_type = var.load_balancer_type
  internal           = var.internal
  security_groups    = [aws_security_group.alb_ingress.id]
  subnets            = var.subnet_ids
#  zone_id            = var.zone_id

  idle_timeout                     = var.idle_timeout
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_deletion_protection       = var.enable_deletion_protection
  ip_address_type                  = var.ip_address_type
  drop_invalid_header_fields       = var.drop_invalid_header_fields

  timeouts {
    create = var.load_balancer_create_timeout
    update = var.load_balancer_update_timeout
    delete = var.load_balancer_delete_timeout
  }

  depends_on = [aws_security_group.alb_ingress]

  tags = {
    Name               = "${var.StackName}"
    TagAPMID           = "${var.TagAPMID}"
    TagBillingApprover = "${var.TagBillingApprover}"
    TagBusinessSegment = "${var.TagBusinessSegment}"
    TagBusinessTower   = "${var.TagBusinessTower}"
    TagCreatedBy       = "${var.TagCreatedBy}"
    Environment        = "${var.Environment}"
    TagFMC             = "${var.TagFMC}"
    TagService         = "${var.TagService}"
    TagSupportGroup    = "${var.TagSupportGroup}"
  }
}

#######################
#PublicECSNginxTG
#######################

resource "aws_lb_target_group" "alb_target_group" {
  count = var.create_lb ? length(var.target_groups) : 0

  name        = "${var.tg_name}-${var.StackName}"
  port        = lookup(var.target_groups[count.index], "backend_port", null)
  protocol    = lookup(var.target_groups[count.index], "backend_protocol", null)
  target_type = lookup(var.target_groups[count.index], "target_type", null)

  vpc_id = var.vpc_id

  stickiness {
    type    = "lb_cookie"
    cookie_duration = 600
    enabled = var.target_group_sticky
  }

  dynamic "health_check" {
    for_each = var.health_check
    content {
      interval            = lookup(health_check.value, "interval", null)
      path                = lookup(health_check.value, "path", null)
      port                = lookup(health_check.value, "port", null)
      healthy_threshold   = lookup(health_check.value, "healthy_threshold", null)
      unhealthy_threshold = lookup(health_check.value, "unhealthy_threshold", null)
      timeout             = lookup(health_check.value, "timeout", null)
      protocol            = lookup(health_check.value, "protocol", null)
    }
  }

  depends_on = [aws_lb.alb]

  tags = {
    Name               = "${var.StackName}"
    TagAPMID           = "${var.TagAPMID}"
    TagBillingApprover = "${var.TagBillingApprover}"
    TagBusinessSegment = "${var.TagBusinessSegment}"
    TagBusinessTower   = "${var.TagBusinessTower}"
    TagCreatedBy       = "${var.TagCreatedBy}"
    Environment        = "${var.Environment}"
    TagFMC             = "${var.TagFMC}"
    TagService         = "${var.TagService}"
    TagSupportGroup    = "${var.TagSupportGroup}"
  }
}

################
#ALBListener
################

resource "aws_lb_listener" "alb_listener" {
  count = var.create_lb ? length(var.https_listeners) : 0

  load_balancer_arn = aws_lb.alb[0].arn
  port              = var.https_listeners[count.index]["port"]
  protocol          = lookup(var.https_listeners[count.index], "protocol", "HTTPS")
  certificate_arn   = var.https_listeners[count.index]["certificate_arn"]
  ssl_policy        = lookup(var.https_listeners[count.index], "ssl_policy", var.listener_ssl_policy_default)


  default_action {
    target_group_arn = aws_lb_target_group.alb_target_group[0].arn
    type             = "forward"
  }
}

##################################################
#ECSNginxListenerRule && ECSNginxIDMListenerRule
##################################################

resource "aws_lb_listener_rule" "https_listener_rule" {
  count = var.create_lb && length(var.https_listener_rules) > 0 ? length(var.https_listener_rules) : 0

  listener_arn = aws_lb_listener.alb_listener[lookup(var.https_listener_rules[count.index], "https_listener_index", count.index)].arn
  priority     = lookup(var.https_listener_rules[count.index], "priority", null)

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group[0].id
  }

  dynamic "condition" {
    for_each = var.host_name
    content {
      host_header {
       values = [element(var.host_name, count.index)]
      }
    }
  }

  depends_on = [aws_lb_target_group.alb_target_group]
}
