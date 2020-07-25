resource "kubernetes_namespace" "kubernetes_dashboard" {
  metadata {
    name = "kubernetes-dashboard"
  }
}

resource "helm_release" "kubernetes_dashboard" {
  name      = format("%s-kubernetes-dashboard", local.cluster_config.cluster_name)
  chart     = "${path.module}/installation-dependencies/helm-charts/kubernetes-dashboard"
  namespace = kubernetes_namespace.kubernetes_dashboard.id

  set_string {
    name  = "service.nodePort"
    value = local.ingress_config.k8s_dashboard_node_port
  }

  values = [
    file("${path.module}/installation-dependencies/env-files/node-affinity-kube-system.yaml")
  ]
}

resource "kubernetes_cluster_role_binding" "kubernetes_dashboard" {
  metadata {
    name = "eks-admin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "eks-admin"
    namespace = "kube-system"
  }
}

resource "kubernetes_service_account" "kubernetes_dashboard" {
  metadata {
    name      = "eks-admin"
    namespace = "kube-system"
  }
}

resource "aws_alb_target_group" "k8s_dashboard_target_group" {
  name     = format("%s-dsbrd-tg", local.cluster_config.cluster_name)
  port     = local.ingress_config.k8s_dashboard_node_port
  protocol = "HTTPS"
  vpc_id   = module.vpc.vpc_id

  health_check {
    enabled             = true
    interval            = 5
    protocol            = "HTTPS"
    path                = "/" // todo add proper path
    port                = local.ingress_config.k8s_dashboard_node_port
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 2
  }

  tags = merge(
    local.common_tags,
    map(
      "Name", format("%s-k8s-dashboard-tg", local.cluster_config.cluster_name)
    )
  )
}

resource "aws_alb_listener_rule" "k8s_dashboard_alb_listener_rule" {
  listener_arn = aws_lb_listener.application_lb_https_listener.arn
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.k8s_dashboard_target_group.arn
  }
  condition {
    host_header {
      values = [
        local.dns_config.k8s_dashboard_domain_name
      ]
    }
  }
}

resource "aws_route53_record" "k8s_dashboard_record" {
  zone_id = local.dns_params.route53_zone_id
  name    = local.dns_config.k8s_dashboard_domain_name
  type    = "A"

  alias {
    name                   = aws_lb.external_application_load_balancer.dns_name
    zone_id                = aws_lb.external_application_load_balancer.zone_id
    evaluate_target_health = true
  }
}


