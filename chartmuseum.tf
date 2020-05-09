resource "kubernetes_namespace" "chartmuseum" {
  metadata {
    name = "chartmuseum"
  }
}

data "template_file" "chartmuseum_envs" {
  template = file("${path.module}/installation-dependencies/env-files/chartmuseum-env.yaml")

  vars = {
    chartmuseum_storage_bucket = aws_s3_bucket.chartmuseum_storage_bucket.id
    aws_region                 = local.aws_region
    chartmuseum_user           = var.chartmuseum_user
    chartmuseum_password       = var.chartmuseum_password
    chartmuseum_node_port      = local.ingress_config.chartmuseum_node_port
  }
}

resource "helm_release" "chartmuseum" {
  name       = format("%s-chartmuseum", local.cluster_config.cluster_name)
  repository = data.helm_repository.stable.metadata[0].url
  chart      = "chartmuseum"
  version    = "2.12.0"

  namespace = kubernetes_namespace.chartmuseum.id

  values = [
    data.template_file.chartmuseum_envs.rendered,
    file("${path.module}/installation-dependencies/env-files/node-affinity-app.yaml")
  ]
}