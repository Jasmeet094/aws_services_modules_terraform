module "elb_healthy_host_count" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 01
    warning  = 02
  }
  message = "${var.name["elb_healthy_host"]} -\n ${var.elb_alert_message}"
  enable  = var.elb
  query   = "avg(last_5m): ${var.elb_queries["healthy_host"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.elb_trigger_by} < 1"
  name    = var.name["elb_healthy_host"]
  type    = "query alert"
  tags    = var.tags
}

module "elb_unhealthy_host_count" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 02
    warning  = 01
  }
  message = "${var.name["elb_unhealthy_host"]} -\n ${var.elb_alert_message}"
  enable  = var.elb
  query   = "avg(last_5m): ${var.elb_queries["unhealthy_host"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.elb_trigger_by} > 02"
  name    = var.name["elb_unhealthy_host"]
  type    = "query alert"
  tags    = var.tags
}

module "elb_4xx" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 20
    warning  = 10
  }
  message = "${var.name["elb_4xx"]} -\n ${var.elb_alert_message}"
  enable  = var.elb
  query   = "avg(last_5m): ${var.elb_queries["count_4xx"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.elb_trigger_by} > 20"
  name    = var.name["elb_4xx"]
  type    = "query alert"
  tags    = var.tags
}

module "elb_5xx" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 20
    warning  = 10
  }
  message = "${var.name["elb_5xx"]} -\n ${var.elb_alert_message}"
  enable  = var.elb
  query   = "avg(last_5m): ${var.elb_queries["count_5xx"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.elb_trigger_by} > 20"
  name    = var.name["elb_5xx"]
  type    = "query alert"
  tags    = var.tags
}

module "elb_request_count" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 1500
    warning  = 1400
  }
  message = "${var.name["elb_request_count"]} -\n ${var.elb_alert_message}"
  enable  = var.elb
  query   = "avg(last_5m): ${var.elb_queries["request_count"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.elb_trigger_by} > 1500"
  name    = var.name["elb_request_count"]
  type    = "query alert"
  tags    = var.tags
}

module "elb_spillover" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 10
    warning  = 05
  }
  message = "${var.name["elb_spill_over"]} -\n ${var.elb_alert_message}"
  enable  = var.elb
  query   = "avg(last_5m): ${var.elb_queries["spill_over"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.elb_trigger_by} > 10"
  name    = var.name["elb_spill_over"]
  type    = "query alert"
  tags    = var.tags
}

module "elb_latency" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 0.10
    warning  = 0.09
  }
  message = "${var.name["elb_latency"]} -\n ${var.elb_alert_message}"
  enable  = var.elb
  query   = "avg(last_5m): ${var.elb_queries["latency"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.elb_trigger_by} > 0.10"
  name    = var.name["elb_latency"]
  type    = "query alert"
  tags    = var.tags
}

module "elb_target_response_time" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 0.3
    warning  = 0.2
  }
  message = "${var.name["elb_response_time"]} -\n ${var.elb_alert_message}"
  enable  = var.elb
  query   = "avg(last_5m): ${var.elb_queries["response_time"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.elb_trigger_by} > 0.3"
  name    = var.name["elb_response_time"]
  type    = "query alert"
  tags    = var.tags
}

module "elb_surge_queue_length" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 900
    warning  = 800
  }
  message = "${var.name["elb_surge_queue_length"]} -\n ${var.elb_alert_message}"
  enable  = var.elb
  query   = "avg(last_5m): ${var.elb_queries["surge_queue_length"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.elb_trigger_by} > 900"
  name    = var.name["elb_surge_queue_length"]
  type    = "query alert"
  tags    = var.tags
}

module "active_connection" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 900
    warning  = 800
  }
  message = "${var.name["elb_active_connection"]} -\n ${var.elb_alert_message}"
  enable  = var.elb
  query   = "avg(last_5m): ${var.elb_queries["active_connection"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.elb_trigger_by} > 900"
  name    = var.name["elb_active_connection"]
  type    = "query alert"
  tags    = var.tags
}
