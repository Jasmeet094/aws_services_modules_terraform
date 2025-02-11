module "dynamodb" {
  source     = "../.."
  identifier = var.identifier
  attributes = var.attributes
  hash_key   = var.hash_key
}
