resource "helm_release" "prometheus" {
  name = "kube-prometheus-stack"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.chart_version

  namespace        = "prometheus"
  create_namespace = true

  dynamic "set" {
    for_each = var.values
    content {
      name  = set.value["name"]
      value = set.value["value"]
    }
  }
}