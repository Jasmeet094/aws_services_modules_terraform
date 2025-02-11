module "fargate_profile" {
  source = "../../modules/eks-fargate-profile"

  pod_execution_role_arn = module.fargate_profile_role.output.role.arn
  profile_selectors      = var.profile_selectors
  cluster_name           = module.eks.output.eks_cluster.id
  identifier             = "${var.identifier}-default"
  subnet_ids             = module.vpc.output.application_subnets.*.id
}