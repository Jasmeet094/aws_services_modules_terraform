resource "helm_release" "datadog-crds" {
  name       = "datadog-crds"
  repository = "https://helm.datadoghq.com"
  chart      = "datadog-crds"
  version    = var.datadog_crds_helm_chart_version

  namespace        = var.namespace
  create_namespace = true

  set {
    name  = "crds.datadogAgents"
    value = true
  }
  set {
    name  = "crds.datadogMetrics"
    value = true
  }
  set {
    name  = "crds.datadogMonitors"
    value = true
  }
}

resource "helm_release" "datadog-agents" {
  depends_on = [helm_release.datadog-crds]
  name       = "datadog-agents"
  repository = "https://helm.datadoghq.com"
  chart      = "datadog"
  version    = var.datadog_agents_helm_chart_version

  namespace        = var.namespace
  create_namespace = true

  set {
    name  = "clusterAgent.enabled"
    value = true
  }
  set {
    name  = "clusterAgent.metricsProvider.enabled"
    value = true
  }
  set {
    name  = "targetSystem"
    value = "linux"
  }
  set {
    name  = "datadog.apiKey"
    value = var.datadog_agents_api_key
  }
  set {
    name  = "datadog.appKey"
    value = var.datadog_agents_app_key
  }
}