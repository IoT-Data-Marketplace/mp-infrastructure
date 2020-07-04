resource "kubernetes_namespace" "kubernetes_namespace" {
  for_each = local.namespaces
  metadata {
    name   = each.key
    labels = each.value.labels
  }
}