locals {
  identifier = var.append_workspace ? "${var.identifier}-${terraform.workspace}" : var.identifier
}

resource "aws_backup_selection" "main" {
  iam_role_arn = var.iam_role_arn
  resources    = var.resources
  plan_id      = var.plan_id
  name         = local.identifier

  dynamic "selection_tag" {
    for_each = var.selection_tags
    content {
      value = selection_tag.value["value"]
      type  = selection_tag.value["type"]
      key   = selection_tag.value["key"]
    }
  }

}