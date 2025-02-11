module "datadog" {
  source = "../.."
  system = true
  elb    = true
  system_queries = {
    disk_total = "avg:system.disk.total"
    mem_total  = "avg:system.mem.total"
    disk_free  = "avg:system.disk.free"
    mem_used   = "avg:system.mem.used"
    load       = "avg:system.load.norm.5"
    cpu        = "avg:system.cpu.idle"
  }
  elb_queries = {
    surge_queue_length = "avg:aws.elb.surge_queue_length"
    active_connection  = "avg:aws.elb.active_connection_count"
    unhealthy_host     = "avg:aws.elb.unhealthy_host_count"
    response_time      = "avg:aws.elb.target_response_time.average"
    request_count      = "avg:aws.elb.request_count"
    healthy_host       = "avg:aws.elb.healthy_host_count"
    spill_over         = "avg:aws.elb.spillover_count"
    count_4xx          = "avg:aws.elb.httpcode_elb_4xx"
    count_5xx          = "avg:aws.elb.httpcode_elb_5xx"
    latency            = "avg:aws.elb.latency"
  }
  system_trigger_by = "{host,Environment}"
  elb_trigger_by    = "{host,region,Environment}"
  elb_alert_message = <<EOF
Value: {{value}}
Name: {{host.name}}
Region: {{region.name}}
Environment: {{Environment.name}}

{{#is_no_data}}Not receiving data @pagerduty{{/is_no_data}}
{{#is_alert}}@pagerduty{{/is_alert}}
{{#is_warning}}@pagerduty{{/is_warning}}
{{#is_recovery}}@pagerduty{{/is_recovery}}
@slack-alerts
EOF

  system_alert_message = <<EOF
Value: {{value}}
Name: {{host.name}}
Region: {{region.name}}
Environment: {{Environment.name}}

{{#is_no_data}}Not receiving data @pagerduty{{/is_no_data}}
{{#is_alert}}@pagerduty{{/is_alert}}
{{#is_warning}}@pagerduty{{/is_warning}}
{{#is_recovery}}@pagerduty{{/is_recovery}}
@slack-alerts
EOF

}
