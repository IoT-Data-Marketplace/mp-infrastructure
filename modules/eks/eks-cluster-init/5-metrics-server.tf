data "helm_repository" "metrics_server" {
  count = var.install_metrics_server ? 1 : 0
  name  = "metrics_server"
  url   = "https://kubernetes-charts.storage.googleapis.com"
}

resource "helm_release" "metrics_server" {
  count      = var.install_metrics_server ? 1 : 0
  name       = format("%s-metrics-server", local.cluster.name)
  repository = data.helm_repository.metrics_server[0].metadata[0].url
  chart      = "metrics-server"
  version    = "2.9.0"

  namespace = "kube-system"

  values = [
    file("${path.module}/env-files/metrics-server.yaml")
  ]
}