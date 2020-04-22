resource "helm_release" "cluster_autoscaler" {
  count     = var.install_cluster_autoscaler ? 1 : 0
  name      = format("%s-cluster-autoscaler", local.cluster.name)
  chart     = "${path.module}/helm-charts/cluster-autoscaler"
  namespace = "kube-system"

  set_string {
    name  = "clusterName"
    value = local.cluster.name
  }
}