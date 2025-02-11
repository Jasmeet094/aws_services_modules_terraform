locals {
  tags_map        = merge(module.common_tags.output, var.tags)
  tags_map_keys   = keys(local.tags_map)
  tags_map_values = values(local.tags_map)

  tags = flatten([
    for i in range(length(local.tags_map_keys)) : [
      "${local.tags_map_keys[i]}:${local.tags_map_values[i]}"
    ]
  ])
}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags?ref=v0.1.2"
  environment = terraform.workspace
  name        = "[${terraform.workspace}] ${var.name}"
}

resource "datadog_monitor" "monitors" {
  count = var.enable ? 1 : 0

  require_full_window = var.require_full_window
  renotify_interval   = var.renotify_interval
  no_data_timeframe   = var.no_data_timeframe
  notify_no_data      = var.notify_no_data
  new_host_delay      = var.new_host_delay
  notify_audit        = var.notify_audit
  include_tags        = var.include_tags
  thresholds          = var.thresholds
  message             = var.message
  query               = var.query
  type                = var.type
  name                = "[${terraform.workspace}] ${var.name}"
  tags                = local.tags
}
