resource "aws_security_group" "security_group" {
//  name = var.security_group_name
  vpc_id = var.vpc_id

  # Rule-1
  ingress {
    from_port          = var.ingress-rule-1-from-port
    to_port            = var.ingress-rule-1-to-port
    protocol           = var.ingress-rule-1-protocol
    security_groups       = var.ingress-rule-1-sg
    description        = var.ingress-rule-1-description
  }

  # Rule-2
  ingress {
    from_port          = var.ingress-rule-2-from-port
    to_port            = var.ingress-rule-2-to-port
    protocol           = var.ingress-rule-2-protocol
    security_groups    = var.ingress-rule-2-security-groups
    description        = var.ingress-rule-2-description
  }

  # Rule-3
  ingress {
    from_port          = var.ingress-rule-3-from-port
    to_port            = var.ingress-rule-3-to-port
    protocol           = var.ingress-rule-3-protocol
    cidr_blocks        = var.ingress-rule-3-cidrs
    description        = var.ingress-rule-3-description
  }

  # Rule-Egress
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.security_group_name
  }

}