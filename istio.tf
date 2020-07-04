resource "kubernetes_namespace" "istio_operator_namespace" {
  metadata {
    name = "istio-operator"
    labels = {
      istio-operator-managed = "Reconcile"
      istio-injection        = "disabled"
    }
  }
}

resource "helm_release" "istio_operator" {
  chart     = "${path.module}/installation-dependencies/helm-charts/istio-operator"
  name      = "istio-operator"
  namespace = kubernetes_namespace.istio_operator_namespace.id
}

resource "kubernetes_namespace" "istio_system_namespace" {
  depends_on = [helm_release.istio_operator]
  metadata {
    name = "istio-system"
  }
}

resource "helm_release" "istio_control_plane" {
  chart     = "${path.module}/installation-dependencies/helm-charts/istio-control-plane"
  name      = "istio-control-plane"
  namespace = kubernetes_namespace.istio_system_namespace.id
}
