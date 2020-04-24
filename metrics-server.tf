resource "helm_release" "metrics_server" {
  name       = format("%s-metrics-server", local.cluster_config.cluster_name)
  repository = data.helm_repository.stable.metadata[0].url
  chart      = "metrics-server"
  version    = "2.9.0"

  namespace = "kube-system"

  values = [
    file("${path.module}/installation-dependencies/env-files/metrics-server.yaml")
  ]
}