module "backup_vault" {
  source               = "../.."
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
      "Resource": "${module.backup_vault.output.vault.arn}"
    }
  ]
}
POLICY
}

module "backup_plan" {
  source            = "../../modules/backup-plan"
  identifier        = var.identifier
  target_vault_name = module.backup_vault.output.vault.id
}

# Create an IAM Role
module "iam_role" {
  source      = "github.com/nclouds/terraform-aws-iam-role?ref=v1.0.2"
  description = "Example IAM Role for AWS backup"
  iam_policies_to_attach = [
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  ]
  trusted_service_arns = ["backup.amazonaws.com"]
  identifier           = "${var.identifier}-backup-role"
}

module "backup_selection" {
  source       = "../../modules/backup-selection"
  identifier   = var.identifier
  plan_id      = module.backup_plan.output.plan.id
  iam_role_arn = module.iam_role.output.role.arn
  resources    = []
  selection_tags = [{
    type  = "STRINGEQUALS"
    key   = "Name"
    value = "example"
    }
  ]
}
