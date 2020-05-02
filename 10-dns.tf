resource "aws_route53_record" "main_application_record_record" {
  zone_id = local.dns_params.route53_zone_id
  name    = local.dns_params.base_domain_name
  type    = "A"

  alias {
    name                   = aws_lb.external_application_load_balancer.dns_name
    zone_id                = aws_lb.external_application_load_balancer.zone_id
    evaluate_target_health = true
  }
}


resource "aws_route53_record" "chartmuseum_domain_name_record" {
  zone_id = local.dns_params.route53_zone_id
  name    = local.dns_config.chartmuseum_domain_name
  type    = "A"

  alias {
    name                   = aws_lb.external_application_load_balancer.dns_name
    zone_id                = aws_lb.external_application_load_balancer.zone_id
    evaluate_target_health = false
  }
}