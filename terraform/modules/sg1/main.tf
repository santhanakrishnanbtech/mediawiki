resource "aws_security_group" "default" {
  vpc_id = var.vpc_id
  tags = {
    Name = var.security_group_name
  }
}
resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}
resource "aws_security_group_rule" "tcp" {
  count             = var.tcp_ports == "default_null" ? 0 : length(split(",", var.tcp_ports))
  type              = "ingress"
  from_port         = split(",", var.tcp_ports)[count.index]
  to_port           = split(",", var.tcp_ports)[count.index]
  protocol          = "tcp"
  cidr_blocks       =  var.cidr
  security_group_id = aws_security_group.default.id
}

