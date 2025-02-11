locals {
  tags = merge(module.common_tags.output, var.tags)
}

module "common_tags" {
  source      = "git@github.com:nclouds/terraform-aws-common-tags.git?ref=v0.1.2"
  environment = var.environment
  name        = "EC2-VPN-${var.environment}"
}

#tfsec:ignore:aws-autoscaling-enforce-http-token-imds
resource "aws_launch_configuration" "openvpn_launch_config" {
  name_prefix                 = "LC-VPN-${var.environment}-"
  image_id                    = var.ami_id != "" ? var.ami_id : data.aws_ami.openvpn.id
  instance_type               = var.ec2_instance_type
  iam_instance_profile        = aws_iam_instance_profile.openvpn_profile.name
  security_groups             = [module.openvpn-sg.output.security_group.id]
  associate_public_ip_address = true #tfsec:ignore:aws-autoscaling-no-public-ip
  key_name                    = var.key_name
  user_data_base64 = base64encode(templatefile("${path.module}/remote_scripts/user-data.sh.tpl", {
    use_rds             = var.use_rds
    environment         = "${lower(replace(var.environment, "-", "_"))}"
    domain_name         = var.domain_name
    hosted_zone_id      = var.hosted_zone_id
    rds_master_name     = var.rds_master_name
    rds_master_password = random_password.password.result
    rds_host            = var.use_rds ? "${aws_rds_cluster_instance.db_instance[0].endpoint}" : ""
    openvpn_password    = var.openvpn_password
    openvpn_dns         = var.openvpn_dns
    openvpn_networks    = var.openvpn_networks
    eip                 = aws_eip.openvpn.id
  }))
  root_block_device {
    encrypted = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "openvpn" {
  name                 = "EC2-VPN-ASG-${var.environment}"
  launch_configuration = aws_launch_configuration.openvpn_launch_config.name
  vpc_zone_identifier  = length(var.public_subnet_ids) == 0 ? tolist(data.aws_subnets.public.*.ids) : var.public_subnet_ids
  min_size             = 1
  max_size             = 1
  desired_capacity     = 1

  lifecycle {
    create_before_destroy = true
  }

  dynamic "tag" {
    for_each = local.tags
    content {
      propagate_at_launch = true
      value               = tag.value
      key                 = tag.key
    }
  }
}

resource "aws_autoscaling_group_tag" "tags" {

  for_each = local.tags

  autoscaling_group_name = aws_autoscaling_group.openvpn.name

  tag {
    key                 = each.key
    value               = each.value
    propagate_at_launch = true
  }
}
