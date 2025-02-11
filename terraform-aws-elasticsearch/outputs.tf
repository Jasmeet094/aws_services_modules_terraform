output "output" {
  value = {
    domain  = aws_elasticsearch_domain.es_domain
    kms_key = module.kms.output
  }
}
