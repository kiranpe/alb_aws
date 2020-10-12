####################
#ALBSecurityGroup
####################

locals {
  security_tags = {
    Name = "${terraform.workspace}-alb-security-group"
  }
}

resource "aws_security_group" "alb_ingress" {
  name   = "${terraform.workspace}_alb_ingress"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.ports

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "ALB Internal Security Group"
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "ALB Internal Security Group"
  }

  tags = local.security_tags
}
