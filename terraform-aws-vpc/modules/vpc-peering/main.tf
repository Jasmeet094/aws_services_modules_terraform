locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier
  tags       = merge(module.common_tags.output, var.tags)
}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags?ref=v0.1.2"
  environment = terraform.workspace
  name        = local.identifier
}

data "aws_caller_identity" "accepter" {
  provider = aws.accepter
}

data "aws_region" "accepter" {
  provider = aws.accepter
}

resource "aws_vpc_peering_connection" "peering" {
  provider = aws.requester

  peer_region = data.aws_region.accepter.name

  peer_owner_id = data.aws_caller_identity.accepter.account_id
  peer_vpc_id   = var.accepter
  auto_accept   = false
  vpc_id        = var.requester
  tags          = merge(local.tags, { Side = "Requester" })
}

resource "aws_vpc_peering_connection_accepter" "peer_accept" {
  provider = aws.accepter

  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  auto_accept               = true
  tags                      = merge(local.tags, { Side = "Accepter" })

  accepter {
    allow_remote_vpc_dns_resolution = var.accepter_allow_remote_vpc_dns_resolution
  }
}

resource "aws_vpc_peering_connection_options" "peering_options" {
  provider = aws.requester

  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  depends_on                = [aws_vpc_peering_connection_accepter.peer_accept]

  requester {
    allow_remote_vpc_dns_resolution = var.requester_allow_remote_vpc_dns_resolution
  }
}

resource "aws_route" "requester_peering_routes" {
  provider = aws.requester
  count    = length(toset(var.requester_route_tables))

  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  destination_cidr_block    = var.accepter_cidr
  route_table_id            = var.requester_route_tables[count.index]
  depends_on                = [aws_vpc_peering_connection.peering]

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "accepter_peering_routes" {
  provider = aws.accepter
  count    = length(toset(var.accepter_route_tables))

  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  destination_cidr_block    = var.requester_cidr
  route_table_id            = var.accepter_route_tables[count.index]
  depends_on                = [aws_vpc_peering_connection.peering, aws_vpc_peering_connection_accepter.peer_accept]

  timeouts {
    create = "5m"
  }
}
