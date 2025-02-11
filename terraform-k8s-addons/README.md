<p align="left"><img width="400" height="100" src="https://www.nclouds.com/img/nclouds-logo.svg"></p>  

![Terraform](https://github.com/nclouds/terraform-k8s-addons/workflows/Terraform/badge.svg)
# nCode Library

## terraform-k8s-addons

Collection of kubernetes addons we can install via terraform.


## Usage
## Provider Settings
```
provider "kubernetes" {
  cluster_ca_certificate = base64decode(certificate-authority-data)
  host                   = "https://XXXXXXXXXXXXXXXX.gr7.us-east-1.eks.amazonaws.com"
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", "example"]
  }
}

provider "helm" {
  kubernetes {
    cluster_ca_certificate = base64decode(certificate-authority-data)
    host                   = "https://XXXXXXXXXXXXXXXX.gr7.us-east-1.eks.amazonaws.com"
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", "example"]
    }
  }
}
```
## Module Usage
```hcl
# Nginx Ingress Controller
  module "nginx_ingress_controller" {
      source                  = "git@github.com:nclouds/terraform-aws-eks.git//modules/nginx-ingress-controller?ref=v0.1.9"
      cluster_name            = "example"
      cluster_oidc_issuer_url = "https://oidc.eks.us-east-1.amazonaws.com/id/XXXXXXXXXXXX"
      tags                    = {
          Cost_Center = "XYZ"
        }
  }
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contributing
If you want to contribute to this repository check all the guidelines specified [here](.github/CONTRIBUTING.md) before submitting a new PR.

## Authors

Module managed by [nClouds](https://github.com/nclouds).
