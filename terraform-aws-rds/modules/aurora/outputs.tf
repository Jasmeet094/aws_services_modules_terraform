output "output" {
  value = {
    cluster_instance = aws_rds_cluster_instance.this
    security_group   = aws_security_group.main
    subnet_group     = aws_db_subnet_group.this
    cluster          = aws_rds_cluster.this
    secret           = var.create_random_password ? aws_secretsmanager_secret.master_password.0 : null
  }
}