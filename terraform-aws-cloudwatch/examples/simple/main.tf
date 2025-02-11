module "example_log_group" {
  source            = "../.."
  retention_in_days = 7
  identifier        = var.identifier
}