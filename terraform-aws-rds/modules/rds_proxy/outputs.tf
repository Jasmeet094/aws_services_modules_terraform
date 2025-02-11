output "output" {
  value = {
    proxy = aws_db_proxy.db_proxy
    role  = aws_iam_role.db_role
  }
}
