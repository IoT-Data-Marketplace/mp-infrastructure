resource "aws_acm_certificate" "main_application_certificate" {
  domain_name       = local.dns_params.base_domain_name
  validation_method = "DNS"

  tags = {
    Name        = format("%s-cluster-main-application-certificate", local.cluster_config.cluster_name)
    ClusterName = local.cluster_config.cluster_name
  }
}

resource "aws_acm_certificate_validation" "main_application_certificate_validation" {
  certificate_arn = aws_acm_certificate.main_application_certificate.arn
  validation_record_fqdns = [
    aws_route53_record.wildcard_certificate_validation_record.fqdn
  ]
}

resource "aws_acm_certificate" "wildcard_certificate" {
  domain_name       = local.dns_config.cluster_admin_wildcard_domain
  validation_method = "DNS"

  tags = {
    Name        = format("%s-cluster-admin-wildcard-certificate", local.cluster_config.cluster_name)
    ClusterName = local.cluster_config.cluster_name
  }
}

resource "aws_route53_record" "wildcard_certificate_validation_record" {
  name    = aws_acm_certificate.wildcard_certificate.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.wildcard_certificate.domain_validation_options[0].resource_record_type
  zone_id = local.dns_params.route53_zone_id
  records = [
    aws_acm_certificate.wildcard_certificate.domain_validation_options[0].resource_record_value
  ]
  ttl = 60
}

resource "aws_acm_certificate_validation" "wildcard_certificate_validation" {
  certificate_arn = aws_acm_certificate.wildcard_certificate.arn
  validation_record_fqdns = [
    aws_route53_record.wildcard_certificate_validation_record.fqdn
  ]
}