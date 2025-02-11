output "output" {
  value = {
    requester_routes = aws_route.accepter_peering_routes
    accepter_routes  = aws_route.requester_peering_routes
    connection       = aws_vpc_peering_connection.peering
  }
}
