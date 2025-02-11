module "openvpn-sg" {
  source = "github.com/nclouds/terraform-aws-security-group.git?ref=v0.2.6"

  identifier  = "SG-VPN-${var.environment}"
  description = "Security group for all public internet traffic to the Openvpn server"
  vpc_id      = var.vpc_id


  tags = merge(local.tags, {
    Name = "SG-VPN-${var.environment}"
  })

  ingress_rule_list = [{
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS inbound for Client UI from anywhere"
    },
    {
      from_port   = 943
      to_port     = 943
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTPS inbound for Admin UI from anywhere"
    },
    {
      from_port   = 1194
      to_port     = 1194
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:AWS00
      description = "Allow HTTPS inbound for Connect Client from anywhere"
    }
  ]

  egress_rule_list = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:AWS009
    description = "Egress to All"

  }]

}

module "openvpn-rds-sg" {

  source = "github.com/nclouds/terraform-aws-security-group.git?ref=v0.2.6"

  depends_on = [module.openvpn-sg]

  identifier  = "SG-RDS-VPN-${var.environment}"
  description = "Security group for traffic to the OpenVPN RDS backend"
  vpc_id      = var.vpc_id
  tags = merge(local.tags, {
    Name = "SG-VPN-RDS-${var.environment}"
  })

}

resource "aws_security_group_rule" "openvpn-rds-ingress" {
  description              = "Rule to allow access to RDS from the openvpn instance"
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = module.openvpn-rds-sg.output.security_group.id
  source_security_group_id = module.openvpn-sg.output.security_group.id
}
