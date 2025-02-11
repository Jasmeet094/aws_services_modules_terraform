output "output" {
  value = {
    oidc_provider = var.create_oidc_provider ? aws_iam_openid_connect_provider.this : null
    eks_cluster   = aws_eks_cluster.control_plane
    iam_role      = aws_iam_role.role
    kms_key       = module.kms.output
    log_group     = module.log_group.output.log_group
  }
  sensitive = true
}
