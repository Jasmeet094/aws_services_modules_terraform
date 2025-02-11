provider "aws" {
  region = "us-east-1"
}

provider "null" {
}

data "aws_eks_cluster_auth" "auth" {
  name = module.eks.output.eks_cluster.id
}

provider "kubernetes" {
  host                   = module.eks.output.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(module.eks.output.eks_cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.auth.token
  load_config_file       = false
  version                = "~> 1.9"
}

provider "helm" {
  kubernetes {
    host                   = module.eks.output.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(module.eks.output.eks_cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.output.eks_cluster.name]
      command     = "aws"
    }
  }
}