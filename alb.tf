resource "aws_security_group" "outgroup" {
  name        = "${var.environment}_${var.app_name}_to_elb"
  description = "Allow internet traffic to hit the public network"
  vpc_id      = var.vpc_id

  tags = {
    Application = var.app_name
    Company = "Taxfiler"
    Domain = var.dns_name == "*" ? var.dns_zone_name : "${var.app_name}.${var.dns_zone_name}"
  }
}

resource "aws_security_group_rule" "outgroup_http_inbound" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.outgroup.id
  description       = "Allows HTTP access"

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outgroup_https_inbound" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.outgroup.id
  description       = "Allows SSH access"

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outgroup_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.outgroup.id
  description       = "Allows egress access"

  cidr_blocks       = ["0.0.0.0/0"]
}
