resource "null_resource" "download_istio" {
  triggers = {
    version = var.istio_version
  }
  provisioner "local-exec" {
    command = <<EOF
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${var.istio_version} TARGET_ARCH=x86_64 sh -
EOF
  }
}

resource "helm_release" "istio_base" {
  depends_on = [null_resource.download_istio]
  name       = "istio-base"
  chart      = "istio-${var.istio_version}/manifests/charts/base"

  namespace        = var.istio_namespace
  create_namespace = true

  values = var.istio_yaml_values

  dynamic "set" {
    for_each = var.istio_chart_values
    content {
      name  = set.key
      value = set.value
    }
  }
}

resource "helm_release" "istio_discovery" {
  depends_on = [helm_release.istio_base]
  name       = "istio-discovery"
  chart      = "istio-${var.istio_version}/manifests/charts/istio-control/istio-discovery"

  namespace = var.istio_namespace

  values = var.istio_yaml_values

  dynamic "set" {
    for_each = var.istio_chart_values
    content {
      name  = set.key
      value = set.value
    }
  }
}

resource "helm_release" "istio_ingress" {
  depends_on = [helm_release.istio_base]
  count      = var.use_istio_ingress == true ? 1 : 0
  name       = "istio-ingress"
  chart      = "istio-${var.istio_version}/manifests/charts/istio-control/istio-ingress"

  namespace = var.istio_namespace

  values = var.istio_yaml_values

  dynamic "set" {
    for_each = var.istio_chart_values
    content {
      name  = set.key
      value = set.value
    }
  }
}

resource "helm_release" "istio_egress" {
  depends_on = [helm_release.istio_base]
  count      = var.use_istio_egress == true ? 1 : 0
  name       = "istio-egress"
  chart      = "istio-${var.istio_version}/manifests/charts/istio-control/istio-egress"

  namespace = var.istio_namespace

  values = var.istio_yaml_values

  dynamic "set" {
    for_each = var.istio_chart_values
    content {
      name  = set.key
      value = set.value
    }
  }
}

resource "null_resource" "remove_istio" {
  depends_on = [helm_release.istio_egress, helm_release.istio_ingress, helm_release.istio_discovery]
  triggers = {
    version = var.istio_version
  }
  provisioner "local-exec" {
    command = <<EOF
rm -r istio-${var.istio_version}
EOF
  }
}
