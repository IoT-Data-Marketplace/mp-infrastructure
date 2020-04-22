resource "kubernetes_namespace" "namespaces" {
  for_each = var.namespace_config
  metadata {
    name = each.key
  }
}