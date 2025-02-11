terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 1.9"
    }
  }
}

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
}
