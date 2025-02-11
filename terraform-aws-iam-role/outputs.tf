output "output" {
  value = {
    policy_attachments = aws_iam_role_policy_attachment.attach
    instance_profile   = aws_iam_instance_profile.profile
    role               = aws_iam_role.role
  }
}
