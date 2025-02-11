output "output" {
  value = {
    subnet_group = aws_elasticache_subnet_group.default
    cluster      = aws_elasticache_cluster.redis
  }
}
