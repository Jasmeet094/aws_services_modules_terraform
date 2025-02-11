output "output" {
  value = {
    eks_security_group = module.eks_security_group.output
    worker_role        = module.worker_role.output
    node_group         = module.node_group.output
    eks                = module.eks.output
    vpc                = var.create_vpc ? module.vpc[0].output.vpc.id : "vpc-000fe2b5ddba6bb64"
  }
  sensitive = true
}