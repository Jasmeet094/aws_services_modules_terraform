output "output" {
  value = {
    parameter_group = aws_db_parameter_group.main
    security_group  = module.security_group
    subnet_group    = aws_db_subnet_group.main
    secret_arn      = aws_secretsmanager_secret.master_password.arn
    instance        = aws_db_instance.main
    secret          = aws_secretsmanager_secret.master_password
  }
}
