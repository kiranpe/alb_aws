locals {
  common_tags = {
    Name            = "${var.StackName}"
    BillingApprover = "${var.BillingApprover}"
    CreatedBy       = "${var.CreatedBy}"
    SupportGroup    = "${var.SupportGroup}"
  }
}

###################
#AppLoadBalancer
###################

resource "aws_lb" "alb" {
  count = var.create_lb ? 1 : 0

  name               = "${terraform.workspace}-${var.name}"
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

  tags = local.common_tags
}

##########################
#PrivateTG
##########################

resource "aws_lb_target_group" "alb_target_group" {
  count = var.create_lb ? length(var.target_groups) : 0

  name        = lookup(var.target_groups[count.index], "name", null)
  port        = lookup(var.target_groups[count.index], "backend_port", null)
  protocol    = lookup(var.target_groups[count.index], "backend_protocol", null)
  target_type = lookup(var.target_groups[count.index], "target_type", null)

  vpc_id = var.vpc_id

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 10
    enabled         = var.target_group_sticky
  }

  health_check {
    interval            = lookup(var.health_check[count.index], "interval", null)
    path                = lookup(var.health_check[count.index], "path", null)
    port                = lookup(var.health_check[count.index], "port", null)
    healthy_threshold   = lookup(var.health_check[count.index], "healthy_threshold", null)
    unhealthy_threshold = lookup(var.health_check[count.index], "unhealthy_threshold", null)
    timeout             = lookup(var.health_check[count.index], "timeout", null)
    protocol            = lookup(var.health_check[count.index], "protocol", null)
    matcher             = lookup(var.health_check[count.index], "matcher", null)
  }

  depends_on = [aws_lb.alb]

  tags = local.common_tags
}

################################
#Target Group Attachement
################################

resource "aws_lb_target_group_attachment" "instance" {
  count = var.create_lb ? length(var.target_groups) : 0

  target_group_arn = aws_lb_target_group.alb_target_group[count.index].arn
  target_id        = aws_instance.docker[count.index].id
  port             = lookup(var.health_check[count.index], "port", null)
}
