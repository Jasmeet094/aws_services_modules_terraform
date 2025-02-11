output "output" {
  value = {
    log_group = module.log_group.output.log_group
    function  = aws_lambda_function.function
  }
}
