locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier
  tags       = merge(module.common_tags.output, var.tags)
}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags?ref=v0.1.2"
  environment = terraform.workspace
  name        = local.identifier
}

resource "aws_dynamodb_table" "this" {
  stream_view_type = var.stream_view_type
  stream_enabled   = var.stream_enabled
  write_capacity   = var.write_capacity
  read_capacity    = var.read_capacity
  billing_mode     = var.billing_mode
  range_key        = var.range_key
  hash_key         = var.hash_key
  name             = local.identifier
  tags             = local.tags

  ttl {
    attribute_name = var.ttl_attribute_name
    enabled        = var.ttl_enabled
  }

  point_in_time_recovery {
    enabled = var.point_in_time_recovery_enabled
  }

  dynamic "attribute" {
    for_each = var.attributes

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.local_secondary_indexes

    content {
      non_key_attributes = lookup(local_secondary_index.value, "non_key_attributes", null)
      projection_type    = local_secondary_index.value.projection_type
      range_key          = local_secondary_index.value.range_key
      name               = local_secondary_index.value.name
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes

    content {
      non_key_attributes = lookup(global_secondary_index.value, "non_key_attributes", null)
      projection_type    = global_secondary_index.value.projection_type
      write_capacity     = lookup(global_secondary_index.value, "write_capacity", null)
      read_capacity      = lookup(global_secondary_index.value, "read_capacity", null)
      range_key          = lookup(global_secondary_index.value, "range_key", null)
      hash_key           = global_secondary_index.value.hash_key
      name               = global_secondary_index.value.name
    }
  }

  dynamic "replica" {
    for_each = var.replica_regions

    content {
      region_name = replica.value
    }
  }

  server_side_encryption {
    kms_key_arn = var.server_side_encryption_kms_key_arn
    enabled     = var.server_side_encryption_enabled
  }

  timeouts {
    create = lookup(var.timeouts, "create", null)
    delete = lookup(var.timeouts, "delete", null)
    update = lookup(var.timeouts, "update", null)
  }
}

resource "aws_appautoscaling_target" "table_read" {
  count = length(var.autoscaling_read) > 0 ? 1 : 0

  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
  max_capacity       = var.autoscaling_read["max_capacity"]
  min_capacity       = var.read_capacity
  resource_id        = "table/${aws_dynamodb_table.this.name}"
}

resource "aws_appautoscaling_policy" "table_read_policy" {
  count = length(var.autoscaling_read) > 0 ? 1 : 0

  scalable_dimension = aws_appautoscaling_target.table_read[count.index].scalable_dimension
  service_namespace  = aws_appautoscaling_target.table_read[count.index].service_namespace
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.table_read[count.index].resource_id
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.table_read[count.index].resource_id}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    scale_out_cooldown = lookup(var.autoscaling_read, "scale_out_cooldown")
    scale_in_cooldown  = lookup(var.autoscaling_read, "scale_in_cooldown")
    target_value       = lookup(var.autoscaling_read, "target_value")
  }
}

resource "aws_appautoscaling_target" "table_write" {
  count = length(var.autoscaling_write) > 0 ? 1 : 0

  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
  max_capacity       = var.autoscaling_write["max_capacity"]
  min_capacity       = var.write_capacity
  resource_id        = "table/${aws_dynamodb_table.this.name}"
}

resource "aws_appautoscaling_policy" "table_write_policy" {
  count = length(var.autoscaling_write) > 0 ? 1 : 0

  scalable_dimension = aws_appautoscaling_target.table_write[count.index].scalable_dimension
  service_namespace  = aws_appautoscaling_target.table_write[count.index].service_namespace
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.table_write[count.index].resource_id
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.table_write[count.index].resource_id}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    scale_out_cooldown = lookup(var.autoscaling_write, "scale_out_cooldown")
    scale_in_cooldown  = lookup(var.autoscaling_write, "scale_in_cooldown")
    target_value       = lookup(var.autoscaling_write, "target_value")
  }
}

resource "aws_appautoscaling_target" "index_read" {
  for_each = var.autoscaling_indexes

  scalable_dimension = "dynamodb:index:ReadCapacityUnits"
  service_namespace  = "dynamodb"
  max_capacity       = each.value["read_max_capacity"]
  min_capacity       = each.value["read_min_capacity"]
  resource_id        = "table/${aws_dynamodb_table.this.name}/index/${each.key}"
}

resource "aws_appautoscaling_policy" "index_read_policy" {
  for_each = var.autoscaling_indexes

  scalable_dimension = aws_appautoscaling_target.index_read[each.key].scalable_dimension
  service_namespace  = aws_appautoscaling_target.index_read[each.key].service_namespace
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.index_read[each.key].resource_id
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.index_read[each.key].resource_id}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    scale_out_cooldown = lookup(each.value, "scale_out_cooldown")
    scale_in_cooldown  = lookup(each.value, "scale_in_cooldown")
    target_value       = lookup(each.value, "target_value")
  }
}

resource "aws_appautoscaling_target" "index_write" {
  for_each = var.autoscaling_indexes

  scalable_dimension = "dynamodb:index:WriteCapacityUnits"
  service_namespace  = "dynamodb"
  max_capacity       = each.value["write_max_capacity"]
  min_capacity       = each.value["write_min_capacity"]
  resource_id        = "table/${aws_dynamodb_table.this.name}/index/${each.key}"
}

resource "aws_appautoscaling_policy" "index_write_policy" {
  for_each = var.autoscaling_indexes

  scalable_dimension = aws_appautoscaling_target.index_write[each.key].scalable_dimension
  service_namespace  = aws_appautoscaling_target.index_write[each.key].service_namespace
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.index_write[each.key].resource_id
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.index_write[each.key].resource_id}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    scale_out_cooldown = lookup(each.value, "scale_out_cooldown")
    scale_in_cooldown  = lookup(each.value, "scale_in_cooldown")
    target_value       = lookup(each.value, "target_value")
  }
}
