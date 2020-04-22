resource "helm_release" "kubernetes_dashboard" {
  depends_on = [kubernetes_namespace.namespaces]
  count      = local.k8s_dashboard.install ? 1 : 0
  name       = format("%s-kubernetes-dashboard", local.cluster.name)
  chart      = "${path.module}/helm-charts/kubernetes-dashboard"
  namespace  = "kubernetes-dashboard"

  set_string {
    name  = "service.nodePort"
    value = local.k8s_dashboard.nodePort
  }
}

resource "kubernetes_cluster_role_binding" "kubernetes_dashboard" {
  count = local.k8s_dashboard.install ? 1 : 0
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
  count = local.k8s_dashboard.install ? 1 : 0
  metadata {
    name      = "eks-admin"
    namespace = "kube-system"
  }
}

resource "aws_alb_target_group" "k8s_dashboard_target_group" {
  count    = local.k8s_dashboard.install ? 1 : 0
  name     = format("%s-dsbrd-tg", local.cluster.name)
  port     = local.k8s_dashboard.nodePort
  protocol = "HTTPS"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    interval            = 5
    protocol            = "HTTPS"
    path                = "/" // todo add proper path
    port                = local.k8s_dashboard.nodePort
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 2
  }

  tags = merge(
    var.common_tags,
    map(
      "Name", format("%s-k8s-dashboard-tg", local.cluster.name)
    )
  )
}

resource "aws_alb_listener_rule" "k8s_dashboard_alb_listener_rule" {
  count        = local.k8s_dashboard.install ? 1 : 0
  listener_arn = local.load_balancer_params.https_listener_arn
  action {
    type             = "forward"
    target_group_arn = element(aws_alb_target_group.k8s_dashboard_target_group.*.arn, count.index)
  }
  condition {
    host_header {
      values = [
        local.k8s_dashboard.dashboard_domain_name
      ]
    }
  }
}

resource "aws_route53_record" "k8s_dashboard_record" {
  count   = local.k8s_dashboard.install ? 1 : 0
  zone_id = var.route_53_zone_id
  name    = local.k8s_dashboard.dashboard_domain_name
  type    = "A"

  alias {
    name                   = local.load_balancer_params.dns_name
    zone_id                = local.load_balancer_params.zone_id
    evaluate_target_health = true
  }
}


