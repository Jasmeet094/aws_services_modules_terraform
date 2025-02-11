output "output" {
  value = {
    https_listener = length(var.alb_certificate_arn) > 0 ? aws_lb_listener.https_listener.0 : null
    http_listener  = aws_lb_listener.http_listener
    athena_table   = var.athena_integration ? aws_glue_catalog_table.aws_glue_catalog_table[0] : null
    athena_db      = var.athena_integration ? aws_athena_database.athena_db[0] : null
    alb            = aws_lb.main
    athena_kms_key = module.kms[*].output
  }
}
