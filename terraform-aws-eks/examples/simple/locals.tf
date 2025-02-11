# WORKERS USER DATA
locals {
  worker_node_userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh ${module.eks.output.eks_cluster.id} --kubelet-extra-args '--node-labels=kubelet.kubernetes.io/role=agent'
USERDATA
}
