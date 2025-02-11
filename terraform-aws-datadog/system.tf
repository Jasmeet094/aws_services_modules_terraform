module "system_cpu" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 80
    warning  = 70
  }
  message = "${var.name["system_cpu"]} -\n ${var.system_alert_message}"
  enable  = var.system
  query   = "avg(last_5m): ${var.system_queries["cpu"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.system_trigger_by} > 80"
  name    = var.name["system_cpu"]
  type    = "query alert"
  tags    = var.tags
}

module "system_disk" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 10
    warning  = 20
  }
  message = "${var.name["system_disk"]} -\n ${var.system_alert_message}"
  enable  = var.system
  query   = "avg(last_5m): ( ${var.system_queries["disk_free"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.system_trigger_by} * 100 / ${var.system_queries["disk_total"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.system_trigger_by} ) <= 10"
  name    = var.name["system_disk"]
  type    = "query alert"
  tags    = var.tags
}

module "system_load" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 04
    warning  = 03
  }
  message = "${var.name["system_load"]} -\n ${var.system_alert_message}"
  enable  = var.ecs
  query   = "avg(last_5m): ${var.system_queries["load"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.system_trigger_by} > 04"
  name    = var.name["system_load"]
  type    = "query alert"
  tags    = var.tags
}

module "system_mem" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 80
    warning  = 70
  }
  message = "${var.name["system_mem"]} -\n ${var.system_alert_message}"
  enable  = var.ecs
  query   = "avg(last_5m): ( ${var.system_queries["mem_used"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.system_trigger_by} * 100 / ${var.system_queries["mem_total"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.system_trigger_by} ) >= 80"
  name    = var.name["system_mem"]
  type    = "query alert"
  tags    = var.tags
}
