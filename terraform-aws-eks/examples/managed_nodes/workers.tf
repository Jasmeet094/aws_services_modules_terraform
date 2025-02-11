module "node_group" {
  source        = "../../modules/eks-node-group"
  node_role_arn = module.worker_role.output.role.arn
  cluster_name  = module.eks.output.eks_cluster.name
  identifier    = var.identifier
  subnet_ids    = module.vpc.output.application_subnets.*.id
  depends_on = [
    module.eks
  ]
}

