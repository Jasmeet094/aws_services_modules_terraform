module "node_group" {
  source               = "git@github.com:nclouds/terraform-aws-autoscaling.git?ref=v0.1.8"
  iam_instance_profile = module.worker_role.output.instance_profile.arn
  user_data_base64     = base64encode(local.worker_node_userdata)
  security_groups      = [module.eks_security_group.output.security_group.id]
  eks_cluster_id       = module.eks.output.eks_cluster.id
  instance_type        = var.instance_type
  identifier           = var.identifier
  image_id             = data.aws_ssm_parameter.eks_ami.value
  key_name             = var.key_name
  subnets              = module.vpc.output.application_subnets.*.id
}