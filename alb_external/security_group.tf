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
