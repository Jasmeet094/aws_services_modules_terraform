output "output" {
  value = {
    mount_points = aws_efs_mount_target.this.*
    efs          = aws_efs_file_system.this
  }
}