output "app_dns" {
  value = join("", [
    "http://",
    module.alb.output.alb.dns_name,
    ":",
    var.lb_port
  ])
}