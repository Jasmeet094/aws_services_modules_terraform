module "datadog" {
  source = "../.."
  system = true
  lambda = true
  ecs    = true
  rds    = true
  elb    = true
  alb    = true
  k8s    = true
}