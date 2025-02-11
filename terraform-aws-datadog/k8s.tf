module "diff_in_replica_statefulset" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 2
    warning  = 1
  }
  message = "${var.name["k8s_statefulset"]} -\n ${var.k8s_alert_message}"
  enable  = var.k8s
  query   = "max(last_10m):${var.k8s_queries["desired_replicas_stateful"]}{${var.from["tag"]}:${terraform.workspace}} by ${var.k8s_trigger_by} - ${var.k8s_queries["ready_replicas_stateful"]}{${var.from["tag"]}:${terraform.workspace}} by ${var.k8s_trigger_by} >= 2"
  name    = var.name["k8s_statefulset"]
  type    = "query alert"
  tags    = var.tags
}

module "diff_in_replica_replicaset" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 2
    warning  = 1
  }
  message = "${var.name["k8s_replicaset"]} -\n ${var.k8s_alert_message}"
  enable  = var.k8s
  query   = "max(last_10m):${var.k8s_queries["desired_replicas_rep_set"]}{${var.from["tag"]}:${terraform.workspace}} by ${var.k8s_trigger_by} - ${var.k8s_queries["ready_replicas_rep_set"]}{${var.from["tag"]}:${terraform.workspace}} by ${var.k8s_trigger_by} >= 2"
  name    = var.name["k8s_replicaset"]
  type    = "query alert"
  tags    = var.tags
}

module "diff_in_replicas_deployment" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 2
    warning  = 1
  }
  message = "${var.name["k8s_deployment"]} -\n ${var.k8s_alert_message}"
  enable  = var.k8s
  query   = "max(last_10m):${var.k8s_queries["desired_replicas_deploy"]}{${var.from["tag"]}:${terraform.workspace}} by ${var.k8s_trigger_by} - ${var.k8s_queries["available_replicas_depl"]}{${var.from["tag"]}:${terraform.workspace}} by ${var.k8s_trigger_by} >= 2"
  name    = var.name["k8s_deployment"]
  type    = "query alert"
  tags    = var.tags
}

module "diff_in_nodes_daemonset" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 2
    warning  = 1
  }
  message = "${var.name["k8s_daemonset"]} -\n ${var.k8s_alert_message}"
  enable  = var.k8s
  query   = "max(last_10m):${var.k8s_queries["kuber_desired_daemonset"]}{${var.from["tag"]}:${terraform.workspace}} by ${var.k8s_trigger_by} - ${var.k8s_queries["kuber_ready_daemonset"]}{${var.from["tag"]}:${terraform.workspace}} by ${var.k8s_trigger_by} >= 2"
  name    = var.name["k8s_deployment"]
  type    = "query alert"
  tags    = var.tags
}

module "pod_memory" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 90
    warning  = 80
  }
  message = "${var.name["k8s_pod_mem"]} -\n ${var.k8s_alert_message}"
  enable  = var.k8s
  query   = "avg(last_10m):${var.k8s_queries["kuber_pod_mem_usage"]}{${var.from["tag"]}:${terraform.workspace}} by ${var.k8s_pod_trigger_by} * 100 /  ${var.k8s_queries["kuber_pod_mem_limit"]}{${var.from["tag"]}:${terraform.workspace}} by ${var.k8s_pod_trigger_by} > 90"
  name    = var.name["k8s_pod_mem"]
  type    = "query alert"
  tags    = var.tags
}

module "job_failed" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 1
    warning  = 0
  }
  message = "${var.name["k8s_failed_job"]} -\n ${var.k8s_alert_message}"
  enable  = var.k8s
  query   = "sum(last_10m):${var.k8s_queries["kuber_failed_jobs"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.k8s_trigger_by}.as_count() > 1"
  name    = var.name["k8s_failed_job"]
  type    = "query alert"
  tags    = var.tags
}

module "node_nw_unavailable" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 1
    warning  = 0
  }
  message = "${var.name["node_nw_unavailable"]} -\n ${var.k8s_alert_message}"
  enable  = var.k8s
  query   = "sum(last_10m):${var.k8s_queries["node_nw_unavailable"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.k8s_trigger_by}.as_count() > 1"
  name    = var.name["node_nw_unavailable"]
  type    = "query alert"
  tags    = var.tags
}

module "node_disk_pressure" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 1
    warning  = 0
  }
  message = "${var.name["node_disk_pressure"]} -\n ${var.k8s_alert_message}"
  enable  = var.k8s
  query   = "sum(last_10m):${var.k8s_queries["node_disk_pressure"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.k8s_trigger_by}.as_count() > 1"
  name    = var.name["node_disk_pressure"]
  type    = "query alert"
  tags    = var.tags
}

module "node_mem_pressure" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 1
    warning  = 0
  }
  message = "${var.name["node_mem_pressure"]} -\n ${var.k8s_alert_message}"
  enable  = var.k8s
  query   = "sum(last_10m):${var.k8s_queries["node_mem_pressure"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.k8s_trigger_by}.as_count() > 1"
  name    = var.name["node_mem_pressure"]
  type    = "query alert"
  tags    = var.tags
}

module "node_out_of_disk" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 1
    warning  = 0
  }
  message = "${var.name["node_out_of_disk"]} -\n ${var.k8s_alert_message}"
  enable  = var.k8s
  query   = "sum(last_10m):${var.k8s_queries["node_outof_disk"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.k8s_trigger_by}.as_count() > 1"
  name    = var.name["node_out_of_disk"]
  type    = "query alert"
  tags    = var.tags
}

module "unscheduled_nodes" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 80
    warning  = 90
  }
  message = "${var.name["unscheduled_nodes"]} -\n ${var.k8s_alert_message}"
  enable  = var.k8s
  query   = "max(last_10m):${var.k8s_queries["kuber_node_status"]} {${var.from["tag"]}:${terraform.workspace},status:schedulable} by ${var.k8s_trigger_by} * 100 / ${var.k8s_queries["kuber_node_status"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.k8s_trigger_by} < 80"
  name    = var.name["unscheduled_nodes"]
  type    = "query alert"
  tags    = var.tags
}

module "crashloopbackoff" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 1
  }
  message = "${var.name["k8s_crashloopbackoff"]} -\n ${var.k8s_alert_message}"
  enable  = var.k8s
  query   = "max(last_10m):${var.k8s_queries["kuber_container_waiting"]} {${var.from["tag"]}:${terraform.workspace},reason:crashloopbackoff} by ${var.k8s_trigger_by} >=1"
  name    = var.name["k8s_crashloopbackoff"]
  type    = "query alert"
  tags    = var.tags
}

module "imagepull_backoff" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 1
  }
  message = "${var.name["k8s_imagepull_backoff"]} -\n ${var.k8s_alert_message}"
  enable  = var.k8s
  query   = "max(last_10m):${var.k8s_queries["kuber_container_waiting"]} {${var.from["tag"]}:${terraform.workspace},reason:imagepullbackoff} by ${var.k8s_pod_trigger_by} >=1"
  name    = var.name["k8s_imagepull_backoff"]
  type    = "query alert"
  tags    = var.tags
}