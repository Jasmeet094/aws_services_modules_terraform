module "dynamodb_table" {
  source = "../../"

  identifier     = var.identifier
  hash_key       = "Id"
  range_key      = "hash"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5

  attributes = [
    {
      name = "Id"
      type = "S"
    },
    {
      name = "hash"
      type = "S"
    }
  ]

  autoscaling_read = {
    scale_in_cooldown  = 50
    scale_out_cooldown = 40
    target_value       = 45
    max_capacity       = 10
  }

  autoscaling_write = {
    scale_in_cooldown  = 50
    scale_out_cooldown = 40
    target_value       = 45
    max_capacity       = 10
  }

  autoscaling_indexes = {
    Example = {
      read_max_capacity  = 30
      read_min_capacity  = 10
      write_max_capacity = 30
      write_min_capacity = 10
      scale_in_cooldown  = 50
      scale_out_cooldown = 40
      target_value       = 45
    }
  }

  global_secondary_indexes = [{
    name               = "Example"
    hash_key           = "Id"
    range_key          = "hash"
    projection_type    = "INCLUDE"
    non_key_attributes = ["hash"]
    write_capacity     = 10
    read_capacity      = 10
  }]
}
