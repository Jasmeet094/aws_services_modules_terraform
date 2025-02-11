module "kms" {
  count = var.alb_access_logs_enable && var.athena_integration ? 1 : 0

  source = "github.com/nclouds/terraform-aws-kms.git?ref=v0.1.5"

  append_workspace = false
  deletion_window  = 10
  description      = "This key is used to encrypt bucket objects and athena data"
  identifier       = local.identifier
  tags             = local.tags
}

resource "aws_athena_database" "athena_db" {
  count = var.alb_access_logs_enable && var.athena_integration ? 1 : 0

  bucket = var.bucket_name == "" ? aws_s3_bucket.lb_logs[0].bucket : data.aws_s3_bucket.selected[0].id
  name   = lower(replace(local.identifier, "-", "_"))

  encryption_configuration {
    encryption_option = "SSE_KMS"
    kms_key           = module.kms[0].output.key_arn
  }

}

resource "aws_glue_catalog_table" "aws_glue_catalog_table" {
  count = var.alb_access_logs_enable && var.athena_integration ? 1 : 0

  database_name = aws_athena_database.athena_db[0].id
  table_type    = "EXTERNAL_TABLE"
  name          = "bucket_logs"
  parameters = {
    EXTERNAL = "TRUE"
  }

  storage_descriptor {
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    location      = "s3://${var.bucket_name == "" ? aws_s3_bucket.lb_logs[0].bucket : data.aws_s3_bucket.selected[0].id}/${var.bucket_logs_prefix}/AWSLogs/${data.aws_caller_identity.current.account_id}/elasticloadbalancing/${data.aws_region.current.name}/"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.serde2.RegexSerDe"
      parameters = {
        "serialization.format" = 1
        "input.regex"          = "([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*):([0-9]*) ([^ ]*)[:-]([0-9]*) ([-.0-9]*) ([-.0-9]*) ([-.0-9]*) (|[-0-9]*) (-|[-0-9]*) ([-0-9]*) ([-0-9]*) \"([^ ]*) (.*) (- |[^ ]*)\" \"([^\"]*)\" ([A-Z0-9-_]+) ([A-Za-z0-9.-]*) ([^ ]*) \"([^\"]*)\" \"([^\"]*)\" \"([^\"]*)\" ([-.0-9]*) ([^ ]*) \"([^\"]*)\" \"([^\"]*)\" \"([^ ]*)\" \"([^\\s]+?)\" \"([^\\s]+)\" \"([^ ]*)\" \"([^ ]*)\""
      }
    }

    columns {
      name = "type"
      type = "string"
    }
    columns {
      name = "time"
      type = "string"
    }
    columns {
      name = "elb"
      type = "string"
    }
    columns {
      name = "client_ip"
      type = "string"
    }
    columns {
      name = "client_port"
      type = "int"
    }
    columns {
      name = "target_ip"
      type = "string"
    }
    columns {
      name = "target_port"
      type = "int"
    }
    columns {
      name = "request_processing_time"
      type = "double"
    }
    columns {
      name = "target_processing_time"
      type = "double"
    }
    columns {
      name = "response_processing_time"
      type = "double"
    }
    columns {
      name = "elb_status_code"
      type = "int"
    }
    columns {
      name = "target_status_code"
      type = "string"
    }
    columns {
      name = "received_bytes"
      type = "bigint"
    }
    columns {
      name = "sent_bytes"
      type = "bigint"
    }
    columns {
      name = "request_verb"
      type = "string"
    }
    columns {
      name = "request_url"
      type = "string"
    }
    columns {
      name = "request_proto"
      type = "string"
    }
    columns {
      name = "user_agent"
      type = "string"
    }
    columns {
      name = "ssl_cipher"
      type = "string"
    }
    columns {
      name = "ssl_protocol"
      type = "string"
    }
    columns {
      name = "target_group_arn"
      type = "string"
    }
    columns {
      name = "trace_id"
      type = "string"
    }
    columns {
      name = "domain_name"
      type = "string"
    }
    columns {
      name = "chosen_cert_arn"
      type = "string"
    }
    columns {
      name = "matched_rule_priority"
      type = "string"
    }
    columns {
      name = "request_creation_time"
      type = "string"
    }
    columns {
      name = "actions_executed"
      type = "string"
    }
    columns {
      name = "redirect_url"
      type = "string"
    }
    columns {
      name = "lambda_error_reason"
      type = "string"
    }
    columns {
      name = "target_port_list"
      type = "string"
    }
    columns {
      name = "target_status_code_list"
      type = "string"
    }
    columns {
      name = "classification"
      type = "string"
    }
    columns {
      name = "classification_reason"
      type = "string"
    }
  }
}
