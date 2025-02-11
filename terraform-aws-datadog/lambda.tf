module "lambda_concurrent_executions" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 05
    warning  = 03
  }
  message = "${var.name["lambda_concurrent"]} -\n ${var.lambda_alert_message}"
  enable  = var.lambda
  query   = "avg(last_5m): ${var.lambda_queries["concurrent"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.lambda_trigger_by} > 5"
  name    = var.name["lambda_concurrent"]
  type    = "query alert"
  tags    = var.tags
}

module "lambda_duration" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 250
    warning  = 200
  }
  message = "${var.name["lambda_duration"]} -\n ${var.lambda_alert_message}"
  enable  = var.lambda
  query   = "avg(last_5m): ${var.lambda_queries["duration"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.lambda_trigger_by} > 250"
  name    = var.name["lambda_duration"]
  type    = "query alert"
  tags    = var.tags
}

module "lambda_throtttle_executions" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 05
    warning  = 04
  }
  message = "${var.name["lambda_throttle"]} -\n ${var.lambda_alert_message}"
  enable  = var.lambda
  query   = "avg(last_5m): ${var.lambda_queries["throttle"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.lambda_trigger_by} > 05"
  name    = var.name["lambda_throttle"]
  type    = "query alert"
  tags    = var.tags
}

module "lambda_errors" {
  source = "./modules/datadog-monitor"
  thresholds = {
    critical = 02
    warning  = 01
  }
  message = "${var.name["lambda_errors"]} -\n ${var.lambda_alert_message}"
  enable  = var.lambda
  query   = "avg(last_5m): ${var.lambda_queries["errors"]} {${var.from["tag"]}:${terraform.workspace}} by ${var.lambda_trigger_by} > 02"
  name    = var.name["lambda_errors"]
  type    = "query alert"
  tags    = var.tags
}