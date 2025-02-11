module "ecr" {
  source               = "../.."
  identifier           = "example"
  scan_on_push         = false
  image_tag_mutability = "IMMUTABLE"
  tags                 = var.tags
}
