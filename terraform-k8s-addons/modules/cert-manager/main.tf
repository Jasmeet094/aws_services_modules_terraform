resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = var.chart_version

  namespace        = var.namespace
  create_namespace = var.create_namespace

  values = var.yaml_values

  set {
    name  = "installCRDs"
    value = true
  }

  dynamic "set" {
    for_each = var.chart_values
    content {
      name  = set.key
      value = set.value
    }
  }
}