locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier
  eks        = var.eks_cluster_id != "" ? [1] : []
  tags       = merge(module.common_tags.output, var.tags)
}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags?ref=v0.1.2"
  environment = terraform.workspace
  name        = local.identifier
}

resource "aws_launch_template" "launch_temp" {
  name_prefix            = "${local.identifier}-"
  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  user_data              = var.user_data_base64
  update_default_version = var.update_default_version
  block_device_mappings {
    device_name = var.device_name
    ebs {
      volume_size           = var.volume_size
      volume_type           = var.volume_type
      iops                  = var.iops
      throughput            = var.throughput
      delete_on_termination = var.delete_on_termination
      encrypted             = var.encrypted
    }
  }
  iam_instance_profile {
    arn = var.iam_instance_profile
  }
  monitoring {
    enabled = var.monitoring
  }
  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    security_groups             = var.security_groups
  }

  dynamic "instance_market_options" {
    for_each = var.instance_market_options != null ? [var.instance_market_options] : []
    content {
      market_type = instance_market_options.value.market_type
    }
  }

  credit_specification {
    cpu_credits = var.credit_specification
  }

  metadata_options {
    http_put_response_hop_limit = var.metadata_options.http_put_response_hop_limit
    http_endpoint               = var.metadata_options.http_endpoint
    http_tokens                 = var.metadata_options.http_tokens
  }

  tag_specifications {
    resource_type = var.resource_type
    tags          = local.tags
  }

  tags = local.tags
}


resource "aws_autoscaling_group" "asg" {
  health_check_grace_period = var.health_check_grace_period
  protect_from_scale_in     = var.protect_from_scale_in
  vpc_zone_identifier       = var.subnets
  target_group_arns         = var.target_group_arns
  desired_capacity          = var.min_size
  load_balancers            = var.load_balancers
  name_prefix               = "${local.identifier}-"
  max_size                  = var.max_size
  min_size                  = var.min_size
  launch_template {
    id      = aws_launch_template.launch_temp.id
    version = aws_launch_template.launch_temp.latest_version
  }

  depends_on = [aws_launch_template.launch_temp]

  instance_refresh {
    strategy = "Rolling"
    preferences {
      instance_warmup        = 300
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  lifecycle {
    ignore_changes = [desired_capacity]
  }

  dynamic "tag" {
    for_each = local.tags
    content {
      propagate_at_launch = true
      value               = tag.value
      key                 = tag.key
    }
  }

  dynamic "tag" {
    for_each = local.eks
    content {
      propagate_at_launch = true
      value               = "owned"
      key                 = "kubernetes.io/cluster/${var.eks_cluster_id}"
    }
  }
}
