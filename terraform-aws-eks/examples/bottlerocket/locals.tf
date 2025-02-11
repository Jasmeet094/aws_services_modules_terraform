# WORKERS USER DATA
locals {
  worker_node_userdata = <<USERDATA
[settings]
  motd = "Hello from nclouds_tf!"
  [settings.host-containers]
    [settings.host-containers.admin]
      enabled = false
  [settings.kubernetes]
    api-server = "${module.eks.output.eks_cluster.endpoint}"
    cluster-certificate = "${module.eks.output.eks_cluster.certificate_authority.0.data}"
    cluster-name = "${module.eks.output.eks_cluster.id}"
    [settings.kubernetes.node-labels]
      "alpha.eksctl.io/cluster-name" = "${module.eks.output.eks_cluster.id}"
      "alpha.eksctl.io/nodegroup-name" = "${var.identifier}-${terraform.workspace}"
USERDATA
}
