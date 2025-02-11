output "output" {
  value = {
    eks_security_group = module.eks_security_group.output
    fargate_profile    = module.fargate_profile_role.output
    node_group         = module.fargate_profile.output
    eks                = module.eks.output
    vpc                = module.vpc.output.vpc.id
  }
  sensitive = true
}
