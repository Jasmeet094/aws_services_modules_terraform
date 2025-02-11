output "output" {
  value = {
    Monitor_id   = datadog_monitor.monitors[*].id
    Monitor_name = datadog_monitor.monitors[*].name
  }
}