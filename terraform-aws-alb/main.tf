locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier
  tags       = merge(module.common_tags.output, var.tags)
}

module "common_tags" {
  source      = "github.com/nclouds/terraform-aws-common-tags?ref=v0.1.2"
  environment = terraform.workspace
  name        = local.identifier
}

#tfsec:ignore:aws-s3-block-public-acls
#tfsec:ignore:aws-s3-block-public-policy
#tfsec:ignore:aws-s3-ignore-public-acls
#tfsec:ignore:aws-s3-no-public-buckets
#tfsec:ignore:aws-s3-enable-bucket-logging
#tfsec:ignore:aws-s3-enable-versioning
#tfsec:ignore:aws-s3-specify-public-access-block
resource "aws_s3_bucket" "lb_logs" {
  count = var.alb_access_logs_enable && var.bucket_name == "" ? 1 : 0

  bucket        = "${var.identifier}-alb-logs"
  tags          = local.tags
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  count = var.alb_access_logs_enable && var.bucket_name == "" ? 1 : 0

  bucket = aws_s3_bucket.lb_logs[0].id
  acl    = "private"
}

#tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  count = var.alb_access_logs_enable && var.bucket_name == "" ? 1 : 0

  bucket = aws_s3_bucket.lb_logs[0].id

  #TODO support the other types of encryption
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#tfsec:ignore:aws-s3-enable-versioning
resource "aws_s3_bucket_versioning" "versioning" {
  count = var.alb_access_logs_enable && var.bucket_name == "" ? 1 : 0

  bucket = aws_s3_bucket.lb_logs[0].id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_public_access_block" "lb_logs" {
  count = var.alb_access_logs_enable && var.bucket_name == "" ? 1 : 0

  bucket = aws_s3_bucket.lb_logs[0].id

  restrict_public_buckets = true
  block_public_policy     = true
  ignore_public_acls      = true
  block_public_acls       = true
}

resource "aws_s3_bucket_policy" "alb_logs_policy" {
  count = var.alb_access_logs_enable && var.bucket_name == "" ? 1 : 0

  bucket = var.bucket_name == "" ? aws_s3_bucket.lb_logs[0].bucket : data.aws_s3_bucket.selected[0].id
  policy = data.aws_iam_policy_document.access_alb_logs[0].json
}

resource "aws_lb" "main" {
  drop_invalid_header_fields = var.drop_invalid_header_fields
  security_groups            = var.security_groups
  internal                   = var.lb_is_internal #tfsec:ignore:AWS005
  subnets                    = var.subnet_ids
  name                       = local.identifier

  dynamic "access_logs" {
    for_each = toset(var.alb_access_logs_enable ? ["foo"] : [])

    content {
      enabled = var.alb_access_logs_enable
      bucket  = var.bucket_name == "" ? aws_s3_bucket.lb_logs[0].bucket : data.aws_s3_bucket.selected[0].id
      prefix  = var.bucket_logs_prefix
    }
  }

  tags = local.tags
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.main.id
  protocol          = "HTTP"
  port              = "80"
  tags              = local.tags

  default_action {
    type = "redirect"

    redirect {
      status_code = "HTTP_301"
      protocol    = "HTTPS"
      port        = "443"
    }
  }
}

resource "aws_lb_listener" "https_listener" {
  count = length(var.alb_certificate_arn) > 0 ? 1 : 0

  load_balancer_arn = aws_lb.main.id
  certificate_arn   = var.alb_certificate_arn[0]
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  protocol          = "HTTPS"
  port              = 443
  tags              = local.tags

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_certificate" "certificates" {
  count = length(var.alb_certificate_arn)

  certificate_arn = var.alb_certificate_arn[count.index]
  listener_arn    = aws_lb_listener.https_listener.0.arn
}
