provider "aws" {
  region  = "us-east-2"
  profile = "Terrafrm"
}

locals {
  common_tags = {
    Name            = "${var.StackName}"
    APMID           = "${var.APMID}"
    BillingApprover = "${var.BillingApprover}"
    BusinessSegment = "${var.BusinessSegment}"
    BusinessTower   = "${var.BusinessTower}"
    CreatedBy       = "${var.CreatedBy}"
    Environment     = "${var.Environment}"
    FMC             = "${var.FMC}"
    Service         = "${var.Service}"
    SupportGroup    = "${var.SupportGroup}"
  }
}

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
      cidr_blocks = ["10.0.0.0/8"]
      description = "HTTPS-Internal"
    }
  }

  dynamic "ingress" {
    for_each = var.ports

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["172.16.0.0/12"]
      description = "HTTPS-GlobalProtect"
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

  tags = local.common_tags
}

##########################
#PrivateTG's
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
