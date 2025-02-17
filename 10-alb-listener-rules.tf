resource "aws_alb_listener_rule" "chartmuseum_alb_listener_rule" {
  listener_arn = aws_lb_listener.application_lb_https_listener.arn
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.chartmuseum_target_group.arn
  }
  condition {
    host_header {
      values = [
        local.dns_config.chartmuseum_domain_name
      ]
    }
  }
}

//resource "aws_alb_listener_rule" "mp_api_gateway_alb_listener_rule" {
//  listener_arn = aws_lb_listener.application_lb_https_listener.arn
//  action {
//    type             = "forward"
//    target_group_arn = aws_alb_target_group.mp_api_gateway_target_group.arn
//  }
//  condition {
//    host_header {
//      values = [
//        local.dns_params.base_domain_name
//      ]
//    }
//  }
//
//  condition {
//    path_pattern {
//      values = [
//        "/graphql",
//        "/auth/challenge",
//      ]
//    }
//  }
//
//}