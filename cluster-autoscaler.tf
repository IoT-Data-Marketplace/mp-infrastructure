resource "helm_release" "cluster_autoscaler" {
  name      = format("%s-cluster-autoscaler", local.cluster_config.cluster_name)
  chart     = "${path.module}/installation-dependencies/helm-charts/cluster-autoscaler"
  namespace = "kube-system"

  set_string {
    name  = "clusterName"
    value = local.cluster_config.cluster_name
  }
}