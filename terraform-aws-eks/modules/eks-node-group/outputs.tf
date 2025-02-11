output "output" {
  value = {
    launch_template = aws_launch_template.this
    node_group      = aws_eks_node_group.this
  }
}
