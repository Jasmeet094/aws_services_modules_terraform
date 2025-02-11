module "ecs_cluster_cpu_reservation" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 80
    warning  = 70
  }
  message = "${var.name["clustercpu_reservation"]} -\n ${var.ecs_alert_message}"
  enable  = var.ecs
  query   = "avg(last_5m): ${var.ecs_queries["cpu_reservation"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.ecs_trigger_by} > 80"
  name    = var.name["clustercpu_reservation"]
  type    = "query alert"
  tags    = var.tags
}

module "ecs_cluster_cpu_utilization" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 80
    warning  = 70
  }
  message = "${var.name["clustercpu_utilization"]} -\n ${var.ecs_alert_message}"
  enable  = var.ecs
  query   = "avg(last_5m): ${var.ecs_queries["cpu_utilization"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.ecs_trigger_by} > 80"
  name    = var.name["clustercpu_utilization"]
  type    = "query alert"
  tags    = var.tags
}

module "ecs_cluster_mem_reservation" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 80
    warning  = 70
  }
  message = "${var.name["clustermem_reservation"]} -\n ${var.ecs_alert_message}"
  enable  = var.ecs
  query   = "avg(last_5m): ${var.ecs_queries["mem_reservation"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.ecs_trigger_by} > 80"
  name    = var.name["clustermem_reservation"]
  type    = "query alert"
  tags    = var.tags
}

module "ecs_cluster_mem_utilization" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 80
    warning  = 70
  }
  message = "${var.name["clustermem_utilization"]} -\n ${var.ecs_alert_message}"
  enable  = var.ecs
  query   = "avg(last_5m): ${var.ecs_queries["mem_utilization"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.ecs_trigger_by} > 80"
  name    = var.name["clustermem_utilization"]
  type    = "query alert"
  tags    = var.tags
}

module "ecs_service_cpu_utilization" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 80
    warning  = 70
  }
  message = "${var.name["servicecpu_utilization"]} -\n ${var.ecs_alert_message}"
  enable  = var.ecs
  query   = "avg(last_5m): ${var.ecs_queries["cpu_utilization"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.ecs_trigger_by} > 80"
  name    = var.name["servicecpu_utilization"]
  type    = "query alert"
  tags    = var.tags
}

module "ecs_service_mem_utilization" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 80
    warning  = 70
  }
  message = "${var.name["servicemem_utilization"]} -\n ${var.ecs_alert_message}"
  enable  = var.ecs
  query   = "avg(last_5m): ${var.ecs_queries["mem_utilization"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.ecs_trigger_by} > 80"
  name    = var.name["servicemem_utilization"]
  type    = "query alert"
  tags    = var.tags
}

module "ecs_task_count" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 2
    warning  = 1
  }
  message = "${var.name["count"]} -\n ${var.ecs_alert_message}"
  enable  = var.ecs
  query   = "avg(last_5m):( ${var.ecs_queries["desired"]}{${var.from["tag"]}:${terraform.workspace}} by ${var.ecs_trigger_by} - ${var.ecs_queries["running"]}{${var.from["tag"]}:${terraform.workspace}} by ${var.ecs_trigger_by}) > 2"
  name    = var.name["count"]
  type    = "query alert"
  tags    = var.tags
}

module "unable_to_place_event" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 01
  }
  message = "${var.name["unable_to_place_task"]} -\n ${var.ecs_alert_message}"
  enable  = var.ecs
  query   = "events(\"sources:ecs\" \"unable to place a task\").rollup(\"count\").by(\"service,cluster,region\").last(\"5m\") >= 1"
  name    = var.name["unable_to_place_task"]
  type    = "event-v2 alert"
  tags    = var.tags
}