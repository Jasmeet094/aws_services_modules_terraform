data "aws_vpc" "openvpn" {
  id = var.vpc_id
}

data "aws_availability_zones" "available" {
}

data "aws_region" "current" {}

data "aws_subnets" "public" {
  count = length(var.public_subnet_ids) == 0 ? 1 : 0

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.openvpn.id]
  }

  tags = {
    Name = "*-public-*"
  }
}

data "aws_subnets" "private" {
  count = length(var.private_subnet_ids) == 0 && var.use_rds ? 1 : 0

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.openvpn.id]
  }

  tags = {
    Name = "*-private-*"
  }
}

resource "aws_eip" "openvpn" {
  vpc = true
  tags = merge(local.tags, {
    Name = "EIP-VPN-${var.environment}"
  })
}
