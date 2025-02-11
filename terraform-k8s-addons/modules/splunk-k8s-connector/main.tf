resource "helm_release" "splunk-k8s-connector" {
  name       = "splunk-k8s-connector"
  repository = "https://splunk.github.io/splunk-connect-for-kubernetes/"
  chart      = "splunk-connect-for-kubernetes"
  version    = var.helm_chart_version

  namespace        = var.namespace
  create_namespace = true

  values = [
    "${file(var.values_file_path)}"
  ]

  set {
    name  = "global.splunk.hec.token"
    value = var.splunk_hec_token
    type  = "string"
  }

}