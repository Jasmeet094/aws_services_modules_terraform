output "output" {
  value = {
    queue = aws_sqs_queue.main
    dlq   = var.dead_letter_queue ? aws_sqs_queue.dead_letter_queue : null
  }
}
