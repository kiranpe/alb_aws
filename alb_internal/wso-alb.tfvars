#Tags
########

Environment           = "dev"
APMID              = ""
App                   = ""
FMC                = ""
BillingApprover    = ""
BusinessSegment    = ""
Service            = ""
ClusterName           = "alb"
BusinessTower      = ""
CreatedBy          = ""
SupportGroup       = ""
CertificateArn        = ""
StackName             = "private-alb"
TrafficManagerHostname = ""
Name = ""
LogstashHostname = ""
BPSHostname = ""
GatewayManagerHostname = ""
AnalyticsHostname = ""


#Security Group
################

ports = [80, 443]

#ALB
########

create_lb                        = true
name                             = "PrivateAppLoadBalancer"
load_balancer_type               = "application"
internal                         = true

subnet_ids                       = ["subnet-29a56d42", "subnet-85ea84c9"]

zone_id                          = "Z0319703F0CL8XGIF95X"
idle_timeout                     = 65
enable_cross_zone_load_balancing = false
enable_deletion_protection       = false
ip_address_type                  = "ipv4"
drop_invalid_header_fields       = false
load_balancer_create_timeout     = "10m"
load_balancer_delete_timeout     = "10m"
load_balancer_update_timeout     = "10m"

#Teraget Group
###############

tg_name = ["wso-PSTG1-alb-int", "wso-PSTG1-alb-int-b"]

target_groups = [
  {
    name = "wso-PSTG1-alb-int"
    backend_port     = 9443
    backend_protocol = "HTTPS"
    target_type      = "instance"
  },
  {
    name = "wso-PSTG1-alb-int-b"
    backend_port     = 9443
    backend_protocol = "HTTPS"
    target_type      = "instance"
  },
  {
    name = "wso-GWWTG1-alb-int"
    backend_port     = 8243
    backend_protocol = "HTTPS"
    target_type      = "instance"
  },
  {
    name = "wso-GWMTG1-alb-int"
    backend_port     = 9443
    backend_protocol = "HTTPS"
    target_type      = "instance"
  },
  {
    name = "wso-IDMTG1-alb-int"
    backend_port     = 9443
    backend_protocol = "HTTPS"
    target_type      = "instance"
  },
  {
    name = "wso-TMTG1-alb-int"
    backend_port     = 9443
    backend_protocol = "HTTPS"
    target_type      = "instance"
  },
  {
    name = "wso-BPSTG1-alb-int"
    backend_port     = 9443
    backend_protocol = "HTTPS"
    target_type      = "instance"
  },
  {
    name = "wso-AnltsTG1-alb-int"
    backend_port     = 9444
    backend_protocol = "HTTPS"
    target_type      = "instance"
  },
  {
    name = "wso-GWWTG-alb-int-b"
    backend_port     = 8243
    backend_protocol = "HTTPS"
    target_type      = "instance"
  },
  {
    name = "wso-GWMTG1-alb-int-b"
    backend_port     = 9443
    backend_protocol = "HTTPS"
    target_type      = "instance"
  },
  {
    name = "wso-IDMTG1-alb-int-b"
    backend_port     = 9443
    backend_protocol = "HTTPS"
    target_type      = "instance"
  },
  {
    name = "wso-TMTG1-alb-int-b"
    backend_port     = 9443
    backend_protocol = "HTTPS"
    target_type      = "instance"
  },
  {
    name = "wso-BPSTG1-alb-int-b"
    backend_port     = 9443
    backend_protocol = "HTTPS"
    target_type      = "instance"
  },
  {
    name = "wso-AnltsTG1-alb-int-b"
    backend_port     = 9444
    backend_protocol = "HTTPS"
    target_type      = "instance"
  }
]

vpc_id              = "vpc-ab1ebfc0"
target_group_sticky = false

health_check = [
  {
    interval            = 180
    path                = "/carbon/admin/images/favicon.ico"
    port                = 9443
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    protocol            = "HTTPS"
    matcher             = 200
  },
  {
    interval            = 180
    path                = "/carbon/admin/images/favicon.ico"
    port                = 9443
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    protocol            = "HTTPS"
    matcher             = 200
  },
  {
    interval            = 300
    path                = "/TagServices"
    port                = 8243
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    protocol            = "HTTPS"
    matcher             = 200
  },
  {
    interval            = 300
    path                = "/carbon/admin/images/favicon.ico"
    port                = 9443
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    protocol            = "HTTPS"
    matcher             = 200
  },
  {
    interval            = 60
    path                = "/carbon/admin/images/favicon.ico"
    port                = 9443
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    protocol            = "HTTPS"
    matcher             = 200
  },
  {
    interval            = 60
    path                = "/carbon/admin/images/favicon.ico"
    port                = 9443
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    protocol            = "HTTPS"
    matcher             = 200
  },
  {
    interval            = 60
    path                = "/carbon/admin/images/favicon.ico"
    port                = 9443
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    protocol            = "HTTPS"
    matcher             = 200
  },
  {
    interval            = 60
    path                = "/carbon/admin/images/favicon.ico"
    port                = 9444
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    protocol            = "HTTPS"
    matcher             = 200
  },
  {
    interval            = 300
    path                = "/TagServices"
    port                = 8243
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    protocol            = "HTTPS"
    matcher             = 200
  },
  {
    interval            = 300
    path                = "/carbon/admin/images/favicon.ico"
    port                = 9443
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    protocol            = "HTTPS"
    matcher             = 200
  },
  {
    interval            = 60
    path                = "/carbon/admin/images/favicon.ico"
    port                = 9443
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    protocol            = "HTTPS"
    matcher             = 200
  },
  {
    interval            = 60
    path                = "/carbon/admin/images/favicon.ico"
    port                = 9443
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    protocol            = "HTTPS"
    matcher             = 200
  },
  {
    interval            = 60
    path                = "/carbon/admin/images/favicon.ico"
    port                = 9443
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    protocol            = "HTTPS"
    matcher             = 200
  },
  {
    interval            = 60
    path                = "/carbon/admin/images/favicon.ico"
    port                = 9444
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    protocol            = "HTTPS"
    matcher             = 200
  }
]

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

listener_ssl_policy_default = "ELBSecurityPolicy-TLS-1-2-2017-01"

#Listener Rules
###################

#Replace with GatewayWorkerHostname and IDMHostname values

host_name = ["www.youtube.com", "www.facebook.com"] 

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

rule3 = [
  {
    https_listener_index = 0
    priority             = 3
  }
]

rule4 = [
  {
    https_listener_index = 0
    priority             = 4
  }
]

rule5 = [
  {
    https_listener_index = 0
    priority             = 5
  }
]

rule6 = [
  {
    https_listener_index = 0
    priority             = 6
  }
]

rule7 = [
  {
    https_listener_index = 0
    priority             = 7
  }
]

rule8 = [
  {
    https_listener_index = 0
    priority             = 8
  } 
]
