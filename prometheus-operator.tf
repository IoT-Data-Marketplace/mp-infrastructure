resource "kubernetes_namespace" "prometheus_oporator" {
  metadata {
    name = "prometheus-operator"
  }
}

resource "helm_release" "prometheus_operator" {
  name       = format("%s-prometheus", local.cluster_config.cluster_name)
  repository = data.helm_repository.stable.metadata[0].url
  chart      = "prometheus-operator"
  version    = "9.3.1"
  namespace  = kubernetes_namespace.prometheus_oporator.id

  set {
    name  = "grafana.service.type"
    value = "NodePort"
  }

  set {
    name  = "grafana.service.nodePort"
    value = local.ingress_config.grafana_node_port
  }

  set_sensitive {
    name  = "grafana.adminPassword"
    value = var.grafana_password
  }

  values = [
    file("${path.module}/installation-dependencies/env-files/prometheus-operator-node-affinity-kube-system.yaml")
  ]
}

resource "aws_alb_target_group" "grafana_target_group" {
  name     = format("%s-grafana-tg", local.cluster_config.cluster_name)
  port     = local.ingress_config.grafana_node_port
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    enabled             = true
    interval            = 5
    protocol            = "HTTP"
    path                = "/api/health" // todo add proper path
    port                = local.ingress_config.grafana_node_port
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 2
  }

  tags = merge(
    local.common_tags,
    map(
      "Name", format("%s-grafana-tg", local.cluster_config.cluster_name)
    )
  )
}

resource "aws_alb_listener_rule" "grafana_alb_listener_rule" {
  listener_arn = aws_lb_listener.application_lb_https_listener.arn
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.grafana_target_group.arn
  }
  condition {
    host_header {
      values = [
        local.dns_config.grafana_domain_name
      ]
    }
  }
}

resource "aws_route53_record" "grafana_record" {
  zone_id = local.dns_params.route53_zone_id
  name    = local.dns_config.grafana_domain_name
  type    = "A"

  alias {
    name                   = aws_lb.external_application_load_balancer.dns_name
    zone_id                = aws_lb.external_application_load_balancer.zone_id
    evaluate_target_health = true
  }
}