resource "helm_release" "metrics-server" {
  name       = "metrics-server"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "metrics-server"
  version    = var.metrics_server_chart_version

  namespace        = var.metrics_server_namespace
  create_namespace = var.create_namespace

  values = var.metrics_server_yaml_values

  dynamic "set" {
    for_each = var.metrics_server_chart_values
    content {
      name  = set.key
      value = set.value
    }
  }
}
