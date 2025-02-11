module "alb_healthy_host_count" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 01
    warning  = 02
  }
  message = "${var.name["alb_healthy_host"]} -\n ${var.elb_alert_message}"
  enable  = var.alb
  query   = "avg(last_5m): ${var.alb_queries["healthy_host"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.elb_trigger_by} < 1"
  name    = var.name["alb_healthy_host"]
  type    = "query alert"
  tags    = var.tags
}

module "alb_unhealthy_host_count" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 02
    warning  = 01
  }
  message = "${var.name["alb_unhealthy_host"]} -\n ${var.elb_alert_message}"
  enable  = var.alb
  query   = "avg(last_5m): ${var.alb_queries["unhealthy_host"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.elb_trigger_by} > 02"
  name    = var.name["alb_unhealthy_host"]
  type    = "query alert"
  tags    = var.tags
}

module "alb_4xx" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 20
    warning  = 10
  }
  message = "${var.name["alb_4xx"]} -\n ${var.elb_alert_message}"
  enable  = var.alb
  query   = "avg(last_5m): ${var.alb_queries["count_4xx"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.elb_trigger_by} > 20"
  name    = var.name["alb_4xx"]
  type    = "query alert"
  tags    = var.tags
}

module "alb_5xx" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 20
    warning  = 10
  }
  message = "${var.name["alb_5xx"]} -\n ${var.elb_alert_message}"
  enable  = var.alb
  query   = "avg(last_5m): ${var.alb_queries["count_5xx"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.elb_trigger_by} > 20"
  name    = var.name["alb_5xx"]
  type    = "query alert"
  tags    = var.tags
}

module "alb_request_count" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 1500
    warning  = 1400
  }
  message = "${var.name["alb_request_count"]} -\n ${var.elb_alert_message}"
  enable  = var.alb
  query   = "avg(last_5m): ${var.alb_queries["request_count"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.elb_trigger_by} > 1500"
  name    = var.name["alb_request_count"]
  type    = "query alert"
  tags    = var.tags
}

module "alb_rejected" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 10
    warning  = 05
  }
  message = "${var.name["alb_rejected"]} -\n ${var.elb_alert_message}"
  enable  = var.alb
  query   = "avg(last_5m): ${var.alb_queries["rejected"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.elb_trigger_by} > 10"
  name    = var.name["alb_rejected"]
  type    = "query alert"
  tags    = var.tags
}

module "alb_target_response_time" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 0.3
    warning  = 0.2
  }
  message = "${var.name["alb_response_time"]} -\n ${var.elb_alert_message}"
  enable  = var.alb
  query   = "avg(last_5m): ${var.alb_queries["response_time"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.elb_trigger_by} > 0.3"
  name    = var.name["alb_response_time"]
  type    = "query alert"
  tags    = var.tags
}

module "alb_active_connection" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 900
    warning  = 800
  }
  message = "${var.name["alb_active_connection"]} -\n ${var.elb_alert_message}"
  enable  = var.alb
  query   = "avg(last_5m): ${var.alb_queries["active_connection"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.elb_trigger_by} > 900"
  name    = var.name["alb_active_connection"]
  type    = "query alert"
  tags    = var.tags
}
