output "adminurl" {
  value       = "https://${var.domain_name}:943/admin"
  description = "Admin Access URL for the OpenVPNServer"
}

output "openvpn_security_group_id" {
  value       = module.openvpn-sg.output.security_group.id
  description = "The ID of the openvpn security group"
}

output "openvpn_rds_security_group_id" {
  value       = module.openvpn-rds-sg.output.security_group.id
  description = "The ID of the openvpn RDS security group"
}
