
module "record" {
  source      = "../.."
  domain_name = "ncodelibrary.com"
  records     = ["something.example.com"]
  name        = "example"
  type        = "CNAME"
  ttl         = 300
}