locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier
  tags       = merge(module.common_tags.output, var.tags)
}

module "common_tags" {
  source = "github.com/nclouds/terraform-aws-common-tags?ref=v0.1.2"

  environment = terraform.workspace
  name        = local.identifier
}

module "log_group" {
  source = "github.com/nclouds/terraform-aws-cloudwatch?ref=v0.1.17"
  count  = var.logs_enabled ? 1 : 0

  append_workspace  = false
  identifier        = "vpn/${local.identifier}"
  retention_in_days = 7
  tags              = local.tags
}

resource "aws_ec2_client_vpn_endpoint" "this" {
  description            = local.identifier
  server_certificate_arn = var.server_certificate_arn
  client_cidr_block      = var.client_cidr_block
  security_group_ids     = var.security_group_ids
  vpc_id                 = var.vpc_id
  tags                   = local.tags

  authentication_options {
    self_service_saml_provider_arn = var.self_service_saml_provider_arn
    saml_provider_arn              = var.saml_provider_arn
    type                           = "federated-authentication"
  }

  dynamic "connection_log_options" {
    for_each = var.logs_enabled ? [1] : []
    content {
      cloudwatch_log_group = module.log_group[0].output.log_group.name
      enabled              = var.logs_enabled
    }
  }
}

resource "aws_ec2_client_vpn_network_association" "this" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  subnet_id              = var.network_association
}

resource "aws_ec2_client_vpn_route" "internet" {
  count = var.internet_access_enabled ? 1 : 0

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  destination_cidr_block = "0.0.0.0/0"
  target_vpc_subnet_id   = aws_ec2_client_vpn_network_association.this.subnet_id
  description            = "Internet Access"
}

resource "aws_ec2_client_vpn_authorization_rule" "internet" {
  count = var.internet_access_enabled ? 1 : 0

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  target_network_cidr    = "0.0.0.0/0"
  authorize_all_groups   = true
  description            = "Internet Access"
}

resource "aws_ec2_client_vpn_route" "this" {
  for_each = var.vpn_routes

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  destination_cidr_block = each.value.destination_cidr_block
  target_vpc_subnet_id   = aws_ec2_client_vpn_network_association.this.subnet_id
  description            = each.value.description
}

resource "aws_ec2_client_vpn_authorization_rule" "this" {
  for_each = var.authorization_rules

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  target_network_cidr    = each.value.target_network_cidr
  access_group_id        = each.value.access_group_id
  description            = each.value.description
}