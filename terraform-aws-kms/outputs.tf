output "output" {
  value = {
    key_arn = aws_kms_key.key.arn
    key_id  = aws_kms_key.key.key_id
  }
}
