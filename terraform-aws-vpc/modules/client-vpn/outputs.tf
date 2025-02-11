output "output" {
  value = {
    log_group    = var.logs_enabled ? module.log_group : null
    vpn_endpoint = aws_ec2_client_vpn_endpoint.this
  }
}
