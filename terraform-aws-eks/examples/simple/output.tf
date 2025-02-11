output "output" {
  value = {
    eks_security_group = module.eks_security_group.output
    worker_role        = module.worker_role.output
    node_group         = module.node_group.output
    eks                = module.eks.output
    vpc                = module.vpc.output.vpc.id
  }
  sensitive = true
}
