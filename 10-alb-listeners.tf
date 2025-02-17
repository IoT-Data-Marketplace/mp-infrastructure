resource "aws_lb_listener" "application_lb_http_listener" {
  load_balancer_arn = aws_lb.external_application_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "application_lb_https_listener" {
  load_balancer_arn = aws_lb.external_application_load_balancer.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.main_application_certificate.arn
  ssl_policy        = "ELBSecurityPolicy-FS-2018-06"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.istio_ingress_gateway_tg.arn
  }
}

resource "aws_lb_listener_certificate" "wildcard_certificate" {
  listener_arn    = aws_lb_listener.application_lb_https_listener.arn
  certificate_arn = aws_acm_certificate.wildcard_certificate.arn
}