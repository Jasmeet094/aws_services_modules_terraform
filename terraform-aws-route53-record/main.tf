data "aws_route53_zone" "selected" {
  name         = var.domain_name
  private_zone = var.private_zone
}

resource "aws_route53_record" "record" {
  records = var.records
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.name
  type    = var.type
  ttl     = var.ttl

  dynamic "alias" {
    for_each = var.alias

    content {
      evaluate_target_health = alias.value.evaluate_target_health
      zone_id                = alias.value.zone_id
      name                   = alias.value.name
    }
  }
}
