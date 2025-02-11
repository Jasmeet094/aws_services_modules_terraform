# AWS Virtual Private Cloud Peering Connection (VPC Perring) Terraform Module

Terraform module to provision [`VPC Peering`](https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html) on AWS.

In order to create a VPC Peering connection, you need to create a requester VPC and a accepter VPC first.

## Usage

Create a REQUESTER VPC
```hcl
    module "requester_network" {
        source                  = "app.terraform.io/ncodelibrary/vpc/aws"
        version                 = "0.2.2"
        vpc_settings            = {
            application_subnets = ["10.10.16.0/22", "10.10.20.0/22"]
            public_subnets      = ["10.10.0.0/22", "10.10.4.0/22"]
            dns_hostnames       = true
            data_subnets        = []
            dns_support         = true
            tenancy             = "default"
            cidr                = "10.10.0.0/16"
        }
        multi_nat_gw            = false
        identifier              = "requester_vpc"
        region                  = "us-east-1"
        tags                    = {
            Owner               = "sysops"
            env                 = "dev"
        }
    }
```

Create an ACCEPTER VPC
```hcl
    module "accepter_network" {
        source                  = "app.terraform.io/ncodelibrary/vpc/aws"
        version                 = "0.2.2"
        vpc_settings            = {
            application_subnets = ["10.20.16.0/22", "10.20.20.0/22"]
            public_subnets      = ["10.20.0.0/22", "10.20.4.0/22"]
            dns_hostnames       = true
            data_subnets        = []
            dns_support         = true
            tenancy             = "default"
            cidr                = "10.20.0.0/16"
        }
        multi_nat_gw            = false
        identifier              = "accepter_vpc"
        region                  = "us-east-1"
        tags                    = {
            Owner               = "sysops"
            env                 = "dev"
        }
    }
```

Create a VPC PEERING Connection
```hcl
    module vpc_peering {
        source                  = "app.terraform.io/ncodelibrary/vpc/aws//modules/vpc-peering"
        version                 = "0.2.2"
        requester               = module.requester_network.output.vpc.id
        accepter                = module.accepter_network.output.vpc.id
        accepter_cidr           = module.accepter_network.output.vpc.cidr_block
        requester_cidr          = module.requester_network.output.vpc.cidr_block
        requester_route_tables  = concat(module.requester_network.output.application_route_table.*.id, [module.requester_network.output.public_route_table.id])
        accepter_route_tables   = concat(module.accepter_network.output.application_route_table.*.id, [module.accepter_network.output.public_route_table.id])
        identifier              = "example"
        region                  = "us-east-1"
        tags                    = {
            Owner               = "sysops"
            env                 = "dev"
        }
    }
```


## Examples
Here are some working examples of using this module:
- [`examples`](examples)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.accepter"></a> [aws.accepter](#provider\_aws.accepter) | >= 2.7.0 |
| <a name="provider_aws.requester"></a> [aws.requester](#provider\_aws.requester) | >= 2.7.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_common_tags"></a> [common\_tags](#module\_common\_tags) | github.com/nclouds/terraform-aws-common-tags | v0.1.2 |

## Resources

| Name | Type |
|------|------|
| [aws_route.accepter_peering_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.requester_peering_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_vpc_peering_connection.peering](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |
| [aws_vpc_peering_connection_accepter.peer_accept](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [aws_vpc_peering_connection_options.peering_options](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [aws_caller_identity.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accepter"></a> [accepter](#input\_accepter) | VPC id of the accepter vpc for peering | `string` | `""` | no |
| <a name="input_accepter_allow_remote_vpc_dns_resolution"></a> [accepter\_allow\_remote\_vpc\_dns\_resolution](#input\_accepter\_allow\_remote\_vpc\_dns\_resolution) | Indicates whether a local VPC can resolve public DNS hostnames to private IP addresses when queried from instances in a peer VPC | `bool` | `true` | no |
| <a name="input_accepter_cidr"></a> [accepter\_cidr](#input\_accepter\_cidr) | CIDR range of the accepter vpc for peering | `string` | `""` | no |
| <a name="input_accepter_route_tables"></a> [accepter\_route\_tables](#input\_accepter\_route\_tables) | List of Route tables to add the peering routes on the accepter side | `list(string)` | `[]` | no |
| <a name="input_append_workspace"></a> [append\_workspace](#input\_append\_workspace) | Appends the terraform workspace at the end of resource names, <identifier>-<worspace> | `bool` | `true` | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | Name of the VPC | `string` | `"identifier"` | no |
| <a name="input_region"></a> [region](#input\_region) | Region where the VPC will be deployed | `string` | `"us-west-2"` | no |
| <a name="input_requester"></a> [requester](#input\_requester) | VPC id of the requester vpc for peering | `string` | `""` | no |
| <a name="input_requester_allow_remote_vpc_dns_resolution"></a> [requester\_allow\_remote\_vpc\_dns\_resolution](#input\_requester\_allow\_remote\_vpc\_dns\_resolution) | Indicates whether a local VPC can resolve public DNS hostnames to private IP addresses when queried from instances in a peer VPC | `bool` | `true` | no |
| <a name="input_requester_cidr"></a> [requester\_cidr](#input\_requester\_cidr) | CIDR range of the requester vpc for peering | `string` | `""` | no |
| <a name="input_requester_route_tables"></a> [requester\_route\_tables](#input\_requester\_route\_tables) | List of Route tables to add the peering routes on the requester side | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the resource | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_output"></a> [output](#output\_output) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contributing
If you want to contribute to this repository check all the guidelines specified [here](.github/CONTRIBUTING.md) before submitting a new PR.
