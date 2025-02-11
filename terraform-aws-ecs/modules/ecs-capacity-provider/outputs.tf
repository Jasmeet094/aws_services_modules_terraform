output "output" {
  value = {
    capacity_provider = aws_ecs_capacity_provider.worker_capacity_provider
  }
}