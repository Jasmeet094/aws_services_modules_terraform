module "rds_cpu_utilization" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 80
    warning  = 70
  }
  message = "${var.name["rds_cpu_utilization"]} -\n ${var.rds_alert_message}"
  enable  = var.rds
  query   = "avg(last_5m): ${var.rds_queries["cpu_utilization"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.rds_trigger_by} > 80"
  name    = var.name["rds_cpu_utilization"]
  type    = "query alert"
  tags    = var.tags
}

module "rds_mem_utilization" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 900
    warning  = 1000
  }
  message = "${var.name["rds_mem_utilization"]} -\n ${var.rds_alert_message}"
  enable  = var.rds
  query   = "avg(last_5m): ${var.rds_queries["mem_utilization"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.rds_trigger_by} <= 900"
  name    = var.name["rds_mem_utilization"]
  type    = "query alert"
  tags    = var.tags
}

module "rds_disk_usage" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 10
    warning  = 15
  }
  message = "${var.name["rds_disk_usage"]} -\n ${var.rds_alert_message}"
  enable  = var.rds
  query   = "avg(last_5m): ( ${var.rds_queries["disk_free"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.rds_trigger_by} * 100 / ${var.rds_queries["disk_total"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.rds_trigger_by} ) <= 10"
  name    = var.name["rds_disk_usage"]
  type    = "query alert"
  tags    = var.tags
}

module "rds_disk_queuedepth" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 10
    warning  = 05
  }
  message = "${var.name["rds_disk_queue_depth"]} -\n ${var.rds_alert_message}"
  enable  = var.rds
  query   = "avg(last_5m): ${var.rds_queries["disk_queue_depth"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.rds_trigger_by} > 10"
  name    = var.name["rds_disk_queue_depth"]
  type    = "query alert"
  tags    = var.tags
}

module "rds_replica_lag" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 20
    warning  = 10
  }
  message = "${var.name["rds_replica_lag"]} -\n ${var.rds_alert_message}"
  enable  = var.rds
  query   = "avg(last_5m): ${var.rds_queries["replica_lag"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.rds_trigger_by} > 20"
  name    = var.name["rds_replica_lag"]
  type    = "query alert"
  tags    = var.tags
}

module "rds_db_connections" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 800
    warning  = 700
  }
  message = "${var.name["rds_db_connections"]} -\n ${var.rds_alert_message}"
  enable  = var.rds
  query   = "avg(last_5m): ${var.rds_queries["db_connections"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.rds_trigger_by} > 800"
  name    = var.name["rds_db_connections"]
  type    = "query alert"
  tags    = var.tags
}

module "rds_write_iops" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 1500
    warning  = 1000
  }
  message = "${var.name["rds_write_iops"]} -\n ${var.rds_alert_message}"
  enable  = var.rds
  query   = "avg(last_5m): ${var.rds_queries["write_iops"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.rds_trigger_by} > 1500"
  name    = var.name["rds_write_iops"]
  type    = "query alert"
  tags    = var.tags
}

module "rds_write_latency" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 0.01
    warning  = 0.009
  }
  message = "${var.name["rds_write_latency"]} -\n ${var.rds_alert_message}"
  enable  = var.rds
  query   = "avg(last_5m): ${var.rds_queries["write_latency"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.rds_trigger_by} > 0.01"
  name    = var.name["rds_write_latency"]
  type    = "query alert"
  tags    = var.tags
}

module "rds_write_throughput" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 10900000
    warning  = 9000000
  }
  message = "${var.name["rds_write_throughput"]} -\n ${var.rds_alert_message}"
  enable  = var.rds
  query   = "avg(last_5m): ${var.rds_queries["write_throughput"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.rds_trigger_by} > 10900000"
  name    = var.name["rds_write_throughput"]
  type    = "query alert"
  tags    = var.tags
}

module "rds_read_iops" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 1500
    warning  = 1000
  }
  message = "${var.name["rds_read_iops"]} -\n ${var.rds_alert_message}"
  enable  = var.rds
  query   = "avg(last_5m): ${var.rds_queries["read_iops"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.rds_trigger_by} > 1500"
  name    = var.name["rds_read_iops"]
  type    = "query alert"
  tags    = var.tags
}

module "rds_read_latency" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 0.01
    warning  = 0.009
  }
  message = "${var.name["rds_read_latency"]} -\n ${var.rds_alert_message}"
  enable  = var.rds
  query   = "avg(last_5m): ${var.rds_queries["read_latency"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.rds_trigger_by} > 0.01"
  name    = var.name["rds_read_latency"]
  type    = "query alert"
  tags    = var.tags
}

module "rds_read_throughput" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 10900000
    warning  = 9000000
  }
  message = "${var.name["rds_read_throughput"]} -\n ${var.rds_alert_message}"
  enable  = var.rds
  query   = "avg(last_5m): ${var.rds_queries["read_throughput"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.rds_trigger_by} > 10900000"
  name    = var.name["rds_read_throughput"]
  type    = "query alert"
  tags    = var.tags
}

module "rds_cpucredit_balance" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 10
    warning  = 15
  }
  message = "${var.name["rds_cpu_credit_balance"]} -\n ${var.rds_alert_message}"
  enable  = var.rds
  query   = "avg(last_5m): ${var.rds_queries["cpu_credit_balance"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.rds_trigger_by} < 10"
  name    = var.name["rds_cpu_credit_balance"]
  type    = "query alert"
  tags    = var.tags
}

module "rds_burst_balance" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 20
    warning  = 30
  }
  message = "${var.name["rds_burst_balance"]} -\n ${var.rds_alert_message}"
  enable  = var.rds
  query   = "avg(last_5m): ${var.rds_queries["burst_balance"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.rds_trigger_by} < 20"
  name    = var.name["rds_burst_balance"]
  type    = "query alert"
  tags    = var.tags
}
module "failover" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 01
  }
  message = "${var.name["rds_failover"]} -\n ${var.rds_alert_message}"
  enable  = var.rds
  query   = "events(\"source: rds\" \"RDS failover event\").rollup(\"count\").by(\"name,dbinstanceidentifier,region\").last(\"5m\") >= 1"
  name    = var.name["rds_failover"]
  type    = "event-v2 alert"
  tags    = var.tags
}