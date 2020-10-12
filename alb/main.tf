module "alb_internal" {
  source = "./modules/alb"

  ########
  #Tags
  ########

  App             = "ALB-Internal"
  BillingApprover = "Kiran Peddineni"
  CreatedBy       = "Kiran Peddineni"
  SupportGroup    = "Terraform"
  StackName       = "alb"

  ################
  #Security Group
  ################

  ports = [22, 80, 443, 8080, 8090]

  ########
  #ALB
  ########

  create_lb          = true
  name               = "alb"
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

  target_groups = [
    {
      name             = "ApacheTG"
      backend_port     = 8080
      backend_protocol = "HTTP"
      target_type      = "instance"
    },
    {
      name             = "TomcatTG"
      backend_port     = 8090
      backend_protocol = "HTTP"
      target_type      = "instance"
    },
  ]

  vpc_id              = "vpc-ab1ebfc0"
  target_group_sticky = false

  health_check = [
    {
      interval            = 30
      path                = "/index.html"
      port                = 8080
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout             = 5
      protocol            = "HTTP"
      matcher             = 200
    },
    {
      interval            = 30
      path                = "/webapp/login.html"
      port                = 8090
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout             = 5
      protocol            = "HTTP"
      matcher             = 200
    },
  ]

  ###############
  #Listeners
  ###############

  http_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    },
    {
      port               = 8090
      protocol           = "HTTP"
      target_group_index = 0
    },
  ]

  listener_ssl_policy_default = "ELBSecurityPolicy-2016-08"

  ###################
  #Listener Rules
  ###################

  rule1 = [
    {
      https_listener_index = 0
      priority             = 1
    }
  ]

  rule2 = [
    {
      https_listener_index = 0
      priority             = 2
    }
  ]

  ########################
  #EC2 Instance
  ########################

  instance_type = "t2.micro"
  key_name      = "jenkins"

}
