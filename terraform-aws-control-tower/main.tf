terraform {
  required_providers {
    controltower = {
      source  = "idealo/controltower"
      version = "~> 1.0"
    }
  }
}
provider "controltower" {
  region = var.region
}

resource "controltower_aws_account" "account" {
  name                = var.name
  email               = var.email
  organizational_unit = var.organizational_unit

  sso {
    first_name = var.sso["first_name"]
    last_name  = var.sso["last_name"]
    email      = var.sso["email"]
  }

  lifecycle {
    prevent_destroy = true
  }
}