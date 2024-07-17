resource "aws_lb" "taxfiler_elb" {
  name                   = "${var.environment}-tf-${var.app_name}"
  internal               = false
  load_balancer_type     = "application"
  security_groups        = [aws_security_group.outgroup.id]
  subnets                = var.public_subnet_ids
  desync_mitigation_mode = "defensive"

  tags = {
    Company = "Taxfiler"
    Domain = var.dns_name == "*" ? var.dns_zone_name : "${var.app_name}.${var.dns_zone_name}"
    Application = var.app_name
  }
}

resource "aws_lb_target_group" "taxfiler_fe" {
  name     = "${var.environment}-tf-${var.app_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  stickiness {
    enabled         = true
    type            = "lb_cookie"
    cookie_duration = 86400
  }
  health_check {
    enabled             = true
    interval            = 5
    port                = 80
    protocol            = "HTTP"
    timeout             = 3
    healthy_threshold   = 3
    unhealthy_threshold = 3
    path                = var.lb_config.health_check.path
  }

  tags = {
    Application = var.app_name
    Company = "Taxfiler"
    Domain = var.dns_name == "*" ? var.dns_zone_name : "${var.app_name}.${var.dns_zone_name}"
  }
}

resource "aws_lb_listener" "taxfiler_fe" {
  load_balancer_arn = aws_lb.taxfiler_elb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      protocol    = "HTTPS"
      port        = "443"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "taxfiler_fe_ssl" {
  load_balancer_arn = aws_lb.taxfiler_elb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.acm_cert_arn
  ssl_policy        = var.lb_config.ssl_policy
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.taxfiler_fe.arn
  }
}
