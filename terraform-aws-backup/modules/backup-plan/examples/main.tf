module "backup" {
  source               = "../../.."
  identifier           = var.identifier
  create_backup_policy = true
  backup_vault_policy  = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "default",
  "Statement": [
    {
      "Sid": "default",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "backup:DescribeBackupVault",
        "backup:DeleteBackupVault",
        "backup:PutBackupVaultAccessPolicy",
        "backup:DeleteBackupVaultAccessPolicy",
        "backup:GetBackupVaultAccessPolicy",
        "backup:StartBackupJob",
        "backup:GetBackupVaultNotifications",
        "backup:PutBackupVaultNotifications"
      ],
      "Resource": "${module.backup.output.vault.arn}"
    }
  ]
}
POLICY
  tags                 = var.tags
}

module "backup_plan" {
  source            = "../"
  identifier        = var.identifier
  target_vault_name = module.backup.output.vault.id
  tags              = var.tags
}