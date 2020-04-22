locals {
  cluster = {
    name                       = lookup(var.cluster_params, "cluster_name")
    id                         = lookup(var.cluster_params, "cluster_id")
    aws_region                 = lookup(var.cluster_params, "aws_region")
    endpoint                   = lookup(var.cluster_params, "cluster_endpoint")
    certificate_authority_data = lookup(var.cluster_params, "cluster_certificate_authority_data")
  }

  k8s_dashboard = {
    install               = lookup(var.k8s_dashboard_config, "install")
    nodePort              = lookup(var.k8s_dashboard_config, "nodePort")
    dashboard_domain_name = lookup(var.k8s_dashboard_config, "dashboard_domain_name")
  }

  load_balancer_params = {
    https_listener_arn = lookup(var.load_balancer_params, "https_listener_arn")
    dns_name           = lookup(var.load_balancer_params, "dns_name")
    zone_id            = lookup(var.load_balancer_params, "zone_id")
  }

}