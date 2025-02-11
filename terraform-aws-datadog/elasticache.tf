module "redis_mem" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 2000000000
    warning  = 1800000000
  }
  message = "${var.name["ec_redis_mem"]} -\n ${var.ec_alert_message}"
  enable  = var.ec
  query   = "avg(last_5m): ${var.ec_queries["redis_mem"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.ec_trigger_by} > 2000000000"
  name    = var.name["ec_redis_mem"]
  type    = "query alert"
  tags    = var.tags
}

module "memc_mem" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 2000000000
    warning  = 1800000000
  }
  message = "${var.name["ec_memc_mem"]} -\n ${var.ec_alert_message}"
  enable  = var.ec
  query   = "avg(last_5m): ${var.ec_queries["memc_mem"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.ec_trigger_by} > 2000000000"
  name    = var.name["ec_memc_mem"]
  type    = "query alert"
  tags    = var.tags
}

module "current_conn" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 1000
    warning  = 800
  }
  message = "${var.name["ec_current_conn"]} -\n ${var.ec_alert_message}"
  enable  = var.ec
  query   = "avg(last_5m): ${var.ec_queries["current_conn"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.ec_trigger_by} > 1000"
  name    = var.name["ec_current_conn"]
  type    = "query alert"
  tags    = var.tags
}

module "evictions" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 50
    warning  = 30
  }
  message = "${var.name["ec_evictions"]} -\n ${var.ec_alert_message}"
  enable  = var.ec
  query   = "avg(last_5m): ${var.ec_queries["evictions"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.ec_trigger_by} > 50"
  name    = var.name["ec_evictions"]
  type    = "query alert"
  tags    = var.tags
}

module "lag" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 100
    warning  = 80
  }
  message = "${var.name["ec_lag"]} -\n ${var.ec_alert_message}"
  enable  = var.ec
  query   = "avg(last_5m): ${var.ec_queries["lag"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.ec_trigger_by} > 100"
  name    = var.name["ec_lag"]
  type    = "query alert"
  tags    = var.tags
}

module "host_mem" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 1000000000
    warning  = 1500000000
  }
  message = "${var.name["ec_host_mem"]} -\n ${var.ec_alert_message}"
  enable  = var.ec
  query   = "avg(last_5m): ${var.ec_queries["host_mem"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.ec_trigger_by} < 1000000000"
  name    = var.name["ec_host_mem"]
  type    = "query alert"
  tags    = var.tags
}

module "cpu_utilization" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 70
    warning  = 60
  }
  message = "${var.name["ec_cpu"]} -\n ${var.ec_alert_message}"
  enable  = var.ec
  query   = "avg(last_5m): ${var.ec_queries["cpu"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.ec_trigger_by} > 70"
  name    = var.name["ec_cpu"]
  type    = "query alert"
  tags    = var.tags
}

module "engine_cpu_utilization" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 70
    warning  = 60
  }
  message = "${var.name["ec_engine_cpu"]} -\n ${var.ec_alert_message}"
  enable  = var.ec
  query   = "avg(last_5m): ${var.ec_queries["engine_cpu"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.ec_trigger_by} > 70"
  name    = var.name["ec_engine_cpu"]
  type    = "query alert"
  tags    = var.tags
}

module "ec_failover" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 01
  }
  message = "${var.name["ec_failover"]} -\n ${var.rds_alert_message}"
  enable  = var.ec
  query   = "events(\"sources:elasticache\" \"Failover from master\").rollup(\"count\").by(\"cachenodeid,cacheclusterid,region\").last(\"5m\") >= 1"
  name    = var.name["ec_failover"]
  type    = "event-v2 alert"
  tags    = var.tags
}