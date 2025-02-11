locals {
  configmap_roles = [
    {
      username = "system:node:{{EC2PrivateDNSName}}"
      rolearn  = module.worker_role.output.role.arn
      groups   = concat(["system:bootstrappers", "system:nodes"])
    }
  ]
}

resource "null_resource" "wait_for_cluster" {
  provisioner "local-exec" {
    interpreter = ["/bin/sh", "-c"]
    command     = "for i in `seq 1 60`; do wget --no-check-certificate -O - -q $ENDPOINT/healthz >/dev/null && exit 0 || true; sleep 5; done; echo TIMEOUT && exit 1"

    environment = {
      ENDPOINT = module.eks.output.eks_cluster.endpoint
    }
  }
}

resource "kubernetes_config_map" "aws_auth" {
  depends_on = [null_resource.wait_for_cluster]

  metadata {
    namespace = "kube-system"
    name      = "aws-auth"
  }

  data = {
    mapRoles = yamlencode(local.configmap_roles)
  }
}