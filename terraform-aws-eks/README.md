<p align="left"><img width=400 height="100" src="https://www.nclouds.com/img/nclouds-logo.svg"></p>  

![Terraform](https://github.com/nclouds/terraform-aws-eks/workflows/Terraform/badge.svg)
# nCode Library

## AWS Elastic Kubernetes Services (EKS) Terraform Module

Terraform module to provision [`Managed Kubernetes Clusters`](https://aws.amazon.com/eks/) on AWS.

This module contains a few sub-modules under the [`modules`](modules) folder which provides multiple options / configurations to provision Kubernetes Cluster in several different ways.
Please refer to Usage section below for more details about the available options

## Usage

Simple Configurations:
```hcl

# EKS Cluster
  module "eks" {
    source        = "git@github.com:nclouds/terraform-aws-eks.git?ref=v0.4.11"
    identifier    = "example"
    eks_version   = 1.18
    key_arn       = "arn:aws:kms::xxxxxxx:key/xxxx-xxxx-xxxx-xxxx"
    subnet_ids    = ["subnet-xxxxxx", "subnet-xxxxxx", "subnet-xxxxxx", "subnet-xxxxxx"]
    tags          = {
      Cost_Center = "XYZ"
    }
  }
```

AWS managed Nodes:
```hcl
  module "eks" {
    source        = "git@github.com:nclouds/terraform-aws-eks.git?ref=v0.4.11"
    identifier    = "example"
    eks_version   = 1.18
    key_arn       = "arn:aws:kms::xxxxxxx:key/xxxx-xxxx-xxxx-xxxx"
    subnet_ids    = ["subnet-xxxxxx", "subnet-xxxxxx", "subnet-xxxxxx", "subnet-xxxxxx"]
    tags          = {
      Cost_Center = "XYZ"
    }
  }

  module "node_group" {
    source        = "git@github.com:nclouds/terraform-aws-eks.git//modules/eks-node-group?ref=v0.4.11"
    node_role_arn = "arn:aws:iam::xxxxxxxxx:role/xxxxxxxxxx"
    cluster_name  = module.eks.output.eks_cluster.id
    identifier    = "dummy"
    subnet_ids    = ["subnet-xxxxxx", "subnet-xxxxxx"]
    tags          = {
      Cost_Center = "XYZ"
    }
  }
```

Fargate Profile
```hcl
  module "eks" {
    source        = "git@github.com:nclouds/terraform-aws-eks.git?ref=v0.4.11"
    identifier    = "example"
    eks_version   = 1.18
    key_arn       = "arn:aws:kms::xxxxxxx:key/xxxx-xxxx-xxxx-xxxx"
    subnet_ids    = ["subnet-xxxxxx", "subnet-xxxxxx", "subnet-xxxxxx", "subnet-xxxxxx"]
    tags          = {
      Cost_Center = "XYZ"
    }
  }

  module "fargate_profile" {
    source                  = "git@github.com:nclouds/terraform-aws-eks.git//modules/eks-fargate-profile?ref=v0.4.11"
    pod_execution_role_arn  = "arn:aws:iam::xxxxxxxxx:role/xxxxxxxxxx"
    cluster_name            = module.eks.output.eks_cluster.id
    identifier              = "dummy-default"
    subnet_ids              = ["subnet-xxxxxx", "subnet-xxxxxx"]
    namespace               = "dummy"
    tags                    = {
                Cost_Center = "XYZ"
    }
  }

```

Bottlerocket Instances
```hcl

  data "aws_ssm_parameter" "eks_ami" {
    name = "/aws/service/bottlerocket/aws-k8s-${var.eks_version}/x86_64/latest/image_id"
  }

  module "eks" {
    source            = "git@github.com:nclouds/terraform-aws-eks.git?ref=v0.4.11"
    identifier        = "example"
    eks_version       = 1.18
    key_arn           = "arn:aws:kms::xxxxxxx:key/xxxx-xxxx-xxxx-xxxx"
    subnet_ids        = ["subnet-xxxxxx", "subnet-xxxxxx", "subnet-xxxxxx", "subnet-xxxxxx"]
    tags              = {
          Cost_Center = "XYZ"
    }
  }

  module "node_group" {
    source                = "git@github.com:nclouds/terraform-aws-eks.git//modules/eks-node-group?ref=v0.4.11"
    iam_instance_profile  = "arn:aws:iam::xxxxxxxxx:role/xxxxxxxxxx"
    user_data_base64      = base64encode(local.worker_node_userdata)
    eks_cluster_id        = module.eks.output.eks_cluster.id
    instance_type         = "t3a.medium"
    identifier            = "dummy"
    image_id              = data.aws_ssm_parameter.eks_ami.value
    key_name              = "nclouds-tf"
    subnets               = ["subnet-xxxxxx", "subnet-xxxxxx"]
    tags                  = {
              Cost_Center = "XYZ"
    }
  }
```


## Examples
Here are some working examples of using this module:
- [`examples/simple`](examples/simple)
- [`examples/managed_nodes`](examples/managed_nodes)
- [`examples/fargate`](examples/fargate)
- [`examples/bottlerocket`](examples/bottlerocket)


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_common_tags"></a> [common\_tags](#module\_common\_tags) | github.com/nclouds/terraform-aws-common-tags | v0.1.2 |
| <a name="module_kms"></a> [kms](#module\_kms) | github.com/nclouds/terraform-aws-kms.git | v0.1.5 |
| <a name="module_log_group"></a> [log\_group](#module\_log\_group) | github.com/nclouds/terraform-aws-cloudwatch.git | v0.1.17 |

## Resources

| Name | Type |
|------|------|
| [aws_eks_cluster.control_plane](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_iam_openid_connect_provider.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.extra_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.sg-for-pods](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_append_workspace"></a> [append\_workspace](#input\_append\_workspace) | Appends the terraform workspace at the end of resource names, <identifier>-<worspace> | `bool` | `true` | no |
| <a name="input_client_id_list"></a> [client\_id\_list](#input\_client\_id\_list) | A list of client IDs (also known as audiences) | `list(string)` | <pre>[<br>  "sts.amazonaws.com"<br>]</pre> | no |
| <a name="input_create_oidc_provider"></a> [create\_oidc\_provider](#input\_create\_oidc\_provider) | Create or not an OIDC Provider resource for the cluster. Default 'true' | `bool` | `true` | no |
| <a name="input_eks_endpoint_private_access"></a> [eks\_endpoint\_private\_access](#input\_eks\_endpoint\_private\_access) | Indicates whether the Amazon EKS private API server endpoint is enabled | `bool` | `true` | no |
| <a name="input_eks_endpoint_public_access"></a> [eks\_endpoint\_public\_access](#input\_eks\_endpoint\_public\_access) | Indicates whether or not the Amazon EKS API server is public | `bool` | `false` | no |
| <a name="input_eks_version"></a> [eks\_version](#input\_eks\_version) | Desired Kubernetes master version | `string` | `"1.24"` | no |
| <a name="input_enabled_cluster_log_types"></a> [enabled\_cluster\_log\_types](#input\_enabled\_cluster\_log\_types) | A list of the desired control plane logging to enable | `list(string)` | <pre>[<br>  "api",<br>  "authenticator",<br>  "audit",<br>  "scheduler",<br>  "controllerManager"<br>]</pre> | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | The name for the cluster | `string` | n/a | yes |
| <a name="input_log_group_retention_in_days"></a> [log\_group\_retention\_in\_days](#input\_log\_group\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group | `number` | `30` | no |
| <a name="input_policy_arns"></a> [policy\_arns](#input\_policy\_arns) | List of policy arns to attach to the cluster IAM role | `list(string)` | `[]` | no |
| <a name="input_public_access_cidrs"></a> [public\_access\_cidrs](#input\_public\_access\_cidrs) | Indicates which CIDR blocks can access the Amazon EKS API server endpoint | `list(string)` | `[]` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs to allow communication between your worker nodes and the Kubernetes control plane | `list(string)` | `[]` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs. Must be in at least two different availability zones | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the resource | `map(any)` | `{}` | no |
| <a name="input_thumbprint_list"></a> [thumbprint\_list](#input\_thumbprint\_list) | A list of server certificate thumbprints for the OpenID Connect (OIDC) identity provider's server certificate(s) | `list(string)` | <pre>[<br>  "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_output"></a> [output](#output\_output) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contributing
If you want to contribute to this repository check all the guidelines specified [here](.github/CONTRIBUTING.md) before submitting a new PR.
