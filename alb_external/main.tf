module "alb" {
  source = "./modules/alb_external"

  ########
  #Tags
  ########

  App             = "ALB-External"
  BillingApprover = "Kiran Peddineni"
  CreatedBy       = "Kiran Peddineni"
  SupportGroup    = "Terraform"
  StackName       = "public-alb"

  ################
  #Security Group
  ################

  ports = [22, 80, 443]

  ########
  #ALB
  ########

  create_lb          = true
  name               = "public-alb"
  load_balancer_type = "application"
  internal           = false

  subnet_ids = ["subnet-29a56d42", "subnet-85ea84c9"]

  zone_id                          = "Z0319703F0CL8XGIF95X"
  idle_timeout                     = 65
  enable_cross_zone_load_balancing = false
  enable_deletion_protection       = false
  ip_address_type                  = "ipv4"
  drop_invalid_header_fields       = false
  load_balancer_create_timeout     = "10m"
  load_balancer_delete_timeout     = "10m"
  load_balancer_update_timeout     = "10m"

  ###############
  #Teraget Group
  ###############

  tg_name = "NginxTG"

  target_groups = [
    {
      backend_port     = 80
      backend_protocol = "HTTP"
      target_type      = "instance"
    }
  ]

  vpc_id              = "vpc-ab1ebfc0"
  target_group_sticky = true

  health_check = [
    {
      interval            = 30
      path                = "/index.html"
      port                = 80
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout             = 5
      protocol            = "HTTP"
    }
  ]

  ###############
  #Listeners
  ###############

  http_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
      target_group_index = 0
    }
  ]

  listener_ssl_policy_default = "ELBSecurityPolicy-2016-08"

  ###################
  #Listener Rules
  ###################

  http_listener_rules = [
    {
      http_listener_index = 0
      priority            = 1
    },
    {
      http_listener_index = 0
      priority            = 1
    },
  ]

  ########################
  #EC2 Instance
  ########################

  instance_type = "t2.micro"
  key_name      = "jenkins"

}
