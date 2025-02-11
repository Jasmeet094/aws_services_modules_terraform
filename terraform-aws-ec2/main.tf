locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier

  is_t_instance_type = replace(var.instance_type, "/^t(2|3|3a){1}\\..*$/", "1") == "1" ? true : false

  tags = merge(module.common_tags.output, var.tags)
}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags?ref=v0.1.2"
  environment = terraform.workspace
  name        = local.identifier
}

resource "aws_eip" "elastic_ip" {
  count = var.associate_eip_address && var.eip_allocation_id == null ? 1 : 0

  tags = local.tags
  vpc  = true
}

resource "aws_eip_association" "eip_assoc" {
  count = var.associate_eip_address ? 1 : 0

  allocation_id = var.eip_allocation_id == null ? aws_eip.elastic_ip[0].id : var.eip_allocation_id
  instance_id   = !var.create_spot_instance ? aws_instance.this[0].id : aws_spot_instance_request.this[0].id
}

#tfsec:ignore:aws-ec2-enable-at-rest-encryption
resource "aws_instance" "this" {
  count = !var.create_spot_instance ? 1 : 0

  cpu_threads_per_core = var.cpu_threads_per_core
  user_data_base64     = var.user_data_base64
  cpu_core_count       = var.cpu_core_count
  instance_type        = var.instance_type
  hibernation          = var.hibernation
  user_data            = var.user_data
  ami                  = var.ami

  vpc_security_group_ids = var.vpc_security_group_ids
  availability_zone      = var.availability_zone
  subnet_id              = var.subnet_id

  iam_instance_profile = var.iam_instance_profile
  get_password_data    = var.get_password_data
  monitoring           = var.monitoring
  key_name             = var.key_name

  associate_public_ip_address = var.associate_public_ip_address
  secondary_private_ips       = var.secondary_private_ips
  ipv6_address_count          = var.ipv6_address_count
  ipv6_addresses              = var.ipv6_addresses
  private_ip                  = var.private_ip

  ebs_optimized = var.ebs_optimized

  dynamic "capacity_reservation_specification" {
    for_each = var.capacity_reservation_specification != null ? [var.capacity_reservation_specification] : []

    content {
      capacity_reservation_preference = lookup(capacity_reservation_specification.value, "capacity_reservation_preference", null)

      dynamic "capacity_reservation_target" {
        for_each = lookup(capacity_reservation_specification.value, "capacity_reservation_target", [])

        content {
          capacity_reservation_id = lookup(capacity_reservation_target.value, "capacity_reservation_id", null)
        }
      }
    }
  }

  dynamic "root_block_device" {
    for_each = var.root_block_device

    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
      kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
      throughput            = lookup(root_block_device.value, "throughput", null)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      tags                  = lookup(root_block_device.value, "tags", null)
    }
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device

    content {
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
      throughput            = lookup(ebs_block_device.value, "throughput", null)
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      device_name           = ebs_block_device.value.device_name
    }
  }

  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_device

    content {
      virtual_name = lookup(ephemeral_block_device.value, "virtual_name", null)
      no_device    = lookup(ephemeral_block_device.value, "no_device", null)
      device_name  = ephemeral_block_device.value.device_name
    }
  }

  dynamic "metadata_options" {
    for_each = var.metadata_options != null ? [var.metadata_options] : []

    content {
      http_put_response_hop_limit = lookup(metadata_options.value, "http_put_response_hop_limit", "1")
      http_endpoint               = lookup(metadata_options.value, "http_endpoint", "enabled")
      http_tokens                 = lookup(metadata_options.value, "http_tokens", "required")
    }
  }

  dynamic "network_interface" {
    for_each = var.network_interface

    content {
      delete_on_termination = lookup(network_interface.value, "delete_on_termination", false)
      network_interface_id  = lookup(network_interface.value, "network_interface_id", null)
      device_index          = network_interface.value.device_index
    }
  }

  dynamic "launch_template" {
    for_each = var.launch_template != null ? [var.launch_template] : []

    content {
      id      = lookup(var.launch_template, "id", null)
      name    = lookup(var.launch_template, "name", null)
      version = lookup(var.launch_template, "version", null)
    }
  }

  enclave_options {
    enabled = var.enclave_options_enabled
  }

  source_dest_check                    = length(var.network_interface) > 0 ? null : var.source_dest_check
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  disable_api_termination              = var.disable_api_termination
  placement_group                      = var.placement_group
  tenancy                              = var.tenancy
  host_id                              = var.host_id

  credit_specification {
    cpu_credits = local.is_t_instance_type ? var.cpu_credits : null
  }

  timeouts {
    create = lookup(var.timeouts, "create", null)
    update = lookup(var.timeouts, "update", null)
    delete = lookup(var.timeouts, "delete", null)
  }

  tags        = local.tags
  volume_tags = var.enable_volume_tags ? local.tags : null
}

resource "aws_spot_instance_request" "this" {
  count = var.create_spot_instance ? 1 : 0

  cpu_threads_per_core = var.cpu_threads_per_core
  user_data_base64     = var.user_data_base64
  cpu_core_count       = var.cpu_core_count
  instance_type        = var.instance_type
  hibernation          = var.hibernation
  user_data            = var.user_data
  ami                  = var.ami

  vpc_security_group_ids = var.vpc_security_group_ids
  availability_zone      = var.availability_zone
  subnet_id              = var.subnet_id

  iam_instance_profile = var.iam_instance_profile
  get_password_data    = var.get_password_data
  monitoring           = var.monitoring
  key_name             = var.key_name

  associate_public_ip_address = var.associate_public_ip_address
  secondary_private_ips       = var.secondary_private_ips
  ipv6_address_count          = var.ipv6_address_count
  ipv6_addresses              = var.ipv6_addresses
  private_ip                  = var.private_ip

  ebs_optimized = var.ebs_optimized

  # Spot request specific attributes
  instance_interruption_behavior = var.spot_instance_interruption_behavior
  block_duration_minutes         = var.spot_block_duration_minutes
  wait_for_fulfillment           = var.spot_wait_for_fulfillment
  launch_group                   = var.spot_launch_group
  valid_until                    = var.spot_valid_until
  valid_from                     = var.spot_valid_from
  spot_price                     = var.spot_price
  spot_type                      = var.spot_type
  # End spot request specific attributes

  dynamic "capacity_reservation_specification" {
    for_each = var.capacity_reservation_specification != null ? [var.capacity_reservation_specification] : []

    content {
      capacity_reservation_preference = lookup(capacity_reservation_specification.value, "capacity_reservation_preference", null)

      dynamic "capacity_reservation_target" {
        for_each = lookup(capacity_reservation_specification.value, "capacity_reservation_target", [])

        content {
          capacity_reservation_id = lookup(capacity_reservation_target.value, "capacity_reservation_id", null)
        }
      }
    }
  }

  dynamic "root_block_device" {
    for_each = var.root_block_device

    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
      kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
      throughput            = lookup(root_block_device.value, "throughput", null)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      tags                  = lookup(root_block_device.value, "tags", null)
    }
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device

    content {
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
      throughput            = lookup(ebs_block_device.value, "throughput", null)
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      device_name           = ebs_block_device.value.device_name
    }
  }

  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_device

    content {
      virtual_name = lookup(ephemeral_block_device.value, "virtual_name", null)
      no_device    = lookup(ephemeral_block_device.value, "no_device", null)
      device_name  = ephemeral_block_device.value.device_name
    }
  }

  dynamic "metadata_options" {
    for_each = var.metadata_options != null ? [var.metadata_options] : []

    content {
      http_put_response_hop_limit = lookup(metadata_options.value, "http_put_response_hop_limit", "1")
      http_endpoint               = lookup(metadata_options.value, "http_endpoint", "enabled")
      http_tokens                 = lookup(metadata_options.value, "http_tokens", "optional")
    }
  }

  dynamic "network_interface" {
    for_each = var.network_interface
    content {
      delete_on_termination = lookup(network_interface.value, "delete_on_termination", false)
      network_interface_id  = lookup(network_interface.value, "network_interface_id", null)
      device_index          = network_interface.value.device_index
    }
  }

  dynamic "launch_template" {
    for_each = var.launch_template != null ? [var.launch_template] : []

    content {
      version = lookup(var.launch_template, "version", null)
      name    = lookup(var.launch_template, "name", null)
      id      = lookup(var.launch_template, "id", null)
    }
  }

  enclave_options {
    enabled = var.enclave_options_enabled
  }

  source_dest_check                    = length(var.network_interface) > 0 ? null : var.source_dest_check
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  disable_api_termination              = var.disable_api_termination
  placement_group                      = var.placement_group
  tenancy                              = var.tenancy
  host_id                              = var.host_id

  credit_specification {
    cpu_credits = local.is_t_instance_type ? var.cpu_credits : null
  }

  timeouts {
    create = lookup(var.timeouts, "create", null)
    delete = lookup(var.timeouts, "delete", null)
  }

  tags        = local.tags
  volume_tags = var.enable_volume_tags ? local.tags : null
}