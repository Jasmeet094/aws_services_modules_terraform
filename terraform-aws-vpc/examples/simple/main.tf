# Create a VPC
module "vpc" {
  source     = "../.."
  identifier = "${var.identifier}_vpc"
  region     = "us-east-1"
}