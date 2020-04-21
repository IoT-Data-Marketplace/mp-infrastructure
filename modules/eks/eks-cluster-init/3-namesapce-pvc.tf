resource "kubernetes_namespace" "dr_namespace" {
  for_each = var.namespace_config
  metadata {
    name = each.key
  }
}