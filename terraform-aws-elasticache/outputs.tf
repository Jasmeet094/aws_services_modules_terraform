output "output" {
  value = {
    subnet_group      = aws_elasticache_subnet_group.default
    replication_group = aws_elasticache_replication_group.default
    parameter_group   = aws_elasticache_parameter_group.default
  }
}
