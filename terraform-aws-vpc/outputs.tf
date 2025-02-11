output "output" {
  value = {
    application_route_table = aws_route_table.application
    application_subnets     = local.application_subnets
    public_route_table      = aws_route_table.public
    data_route_table        = aws_route_table.data_subnets
    internet_gateway        = aws_internet_gateway.igw
    nat_elastic_ip          = aws_eip.nat_gw
    public_subnets          = local.public_subnets
    data_subnets            = local.data_subnets
    nat_gateway             = aws_nat_gateway.nat_gw
    log_group               = local.create_cloudwatch_log_group ? module.log_group[0].output.log_group : null
    flow_logs               = var.flow_log_settings["enable_flow_log"] ? aws_flow_log.logs : null
    vpc                     = aws_vpc.vpc
    security_group          = var.create_private_endpoints ? module.endpoint_sg[0].output.security_group.id : null
  }
}
