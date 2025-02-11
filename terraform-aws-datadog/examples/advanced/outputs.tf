output "output" {
  value = {
    monitors = module.datadog.output
  }
}
