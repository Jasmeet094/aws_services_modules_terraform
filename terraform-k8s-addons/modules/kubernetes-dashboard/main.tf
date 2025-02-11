resource "helm_release" "kubernetes_dashboard" {
  name       = "kubernetes-dashboard"
  repository = "https://kubernetes.github.io/dashboard/"
  chart      = "kubernetes-dashboard"
  version    = var.kubernetes_dashboard_chart_version

  namespace        = var.kubernetes_dashboard_namespace
  create_namespace = true

  values = var.kubernetes_dashboard_yaml_values

  dynamic "set" {
    for_each = var.kubernetes_dashboard_chart_values
    content {
      name  = set.key
      value = set.value
    }
  }
}
