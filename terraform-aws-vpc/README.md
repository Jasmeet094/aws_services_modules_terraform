<p align="left"><img width=400 height="100" src="https://www.nclouds.com/img/nclouds-logo.svg"></p>  

![Terraform](https://github.com/nclouds/terraform-aws-vpc/workflows/Terraform/badge.svg)
# nCode Library

## AWS Virtual Private Cloud (VPC) Terraform Module

Terraform module to provision [`VPC Resources`](https://aws.amazon.com/vpc/) on AWS.

This module contains VPC Peering as sub-modules under [`modules`](modules) folder.
In order to create a VPC Peering connection, you need to create a requester VPC and a accepter VPC first.

## Usage

### Simple setup

Create a simple VPC with default configurations.
```hcl
    module "vpc" {
        source = "git@github.com:nclouds/terraform-aws-vpc.git?ref=v0.4.7"
        multi_nat_gw            = false
        vpc_settings            = {
            application_subnets = ["10.10.16.0/22", "10.10.20.0/22"]
            public_subnets      = ["10.10.0.0/22", "10.10.4.0/22"]
            dns_hostnames       = true
            data_subnets        = []
            dns_support         = true
            tenancy             = "default"
            cidr                = "10.10.0.0/16"
        }
        identifier              = "example"
        region                  = "us-east-1"
        tags                    = {
            Owner = "sysops"
            env   = "dev"
        }
    }
```

For more details on a working example, please visit [`examples/simple`](examples/simple)

### Advanced Setup
If you want to create VPC with enhanced configuration e.g VPC Flowlogs etc., you can use the module like this:

Create a S3 bucket for VPC Flowlogs
```hcl
    module "s3" {
        source = "github.com/nclouds/terraform-aws-s3-bucket?ref=v0.2.6"
        identifier  = "example-s3-bucket-for-flow-logs-123"
        tags        = {
            Owner   = "sysops"
            env     = "dev"
        }
    }
```

Create a VPC
```hcl
    module "vpc" {
        source = "git@github.com:nclouds/terraform-aws-vpc.git?ref=v0.4.7"
        multi_nat_gw                = true
        s3_flow_log_bucket          = module.s3.output.bucket.arn
        flow_log_settings           = {
            log_destination_type    = "s3"
            enable_flow_log         = true
            traffic_type            = "ALL"
        }
        vpc_settings = {
            application_subnets = ["10.10.24.0/22", "10.10.28.0/22", "10.10.32.0/22"]
            public_subnets      = ["10.10.0.0/22", "10.10.4.0/22", "10.10.8.0/22"]
            data_subnets        = ["10.10.12.0/22", "10.10.16.0/22", "10.10.20.0/22"]
            dns_hostnames       = true
            dns_support         = true
            tenancy             = "default"
            cidr                = "10.10.0.0/16"
        }
        identifier              = "example"
        region                  = "us-east-1"
        tags                    = {
            Owner               = "sysops"
            env                 = "dev"
        }
    }
```
For more options refer to a working example at [`examples/advanced`](examples/advanced)

## Examples
Here are some working examples of using this module:
- [`examples/simple`](examples/simple)
- [`examples/advanced`](examples/advanced)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.7.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_common_tags"></a> [common\_tags](#module\_common\_tags) | github.com/nclouds/terraform-aws-common-tags | v0.1.2 |
| <a name="module_endpoint_sg"></a> [endpoint\_sg](#module\_endpoint\_sg) | github.com/nclouds/terraform-aws-security-group.git | v0.2.9 |
| <a name="module_log_group"></a> [log\_group](#module\_log\_group) | github.com/nclouds/terraform-aws-cloudwatch.git | v0.1.17 |

## Resources

| Name | Type |
|------|------|
| [aws_eip.nat_gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_flow_log.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_kms_alias.flow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.flow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_nat_gateway.nat_gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_network_acl.application_layer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl.data_layer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl.public_layer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl_rule.egress-all-app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.egress-all-data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.egress-all-public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.ingress-all-ephemmeral-tcp-app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.ingress-all-ephemmeral-tcp-data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.ingress-all-ephemmeral-tcp-public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.ingress-all-ephemmeral-udp-app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.ingress-all-ephemmeral-udp-data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.ingress-all-internal-app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.ingress-all-internal-data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.ingress-custom-internal-application](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.ingress-custom-internal-application-priority](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.ingress-custom-internal-data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.ingress-custom-internal-data-priority](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_route.application_nat_gateway_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.data_nat_gateway_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.internet_gateway_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.application](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.data_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.application_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.data_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.application_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.data_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_endpoint.ecr_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ecr_dkr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.cloudwatch_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.combined](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_owner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_vpc_endpoint_service.ecr_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint_service) | data source |
| [aws_vpc_endpoint_service.ecr_dkr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint_service) | data source |
| [aws_vpc_endpoint_service.ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint_service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_cidr_blocks_application"></a> [allowed\_cidr\_blocks\_application](#input\_allowed\_cidr\_blocks\_application) | List of allowed CIDR blocks into application subnets via NACL, rule IDs are generated automatically. Only set this after the VPC has been created. (Use 'allowed\_cidr\_blocks\_application\_priority' variable instead. | `list(string)` | `[]` | no |
| <a name="input_allowed_cidr_blocks_application_priority"></a> [allowed\_cidr\_blocks\_application\_priority](#input\_allowed\_cidr\_blocks\_application\_priority) | List of allowed CIDR blocks into application subnets via NACL, rule IDs have to be set manually per CIDR. Only set this after the VPC has been created | <pre>list(object({<br>    rule_id = number,<br>    cidr    = string<br>  }))</pre> | `[]` | no |
| <a name="input_allowed_cidr_blocks_data"></a> [allowed\_cidr\_blocks\_data](#input\_allowed\_cidr\_blocks\_data) | List of allowed CIDR blocks into data subnets via NACL, rule IDs are generated automatically. Only set this after the VPC has been created. (Use 'allowed\_cidr\_blocks\_data\_priority' variable instead.) | `list(string)` | `[]` | no |
| <a name="input_allowed_cidr_blocks_data_priority"></a> [allowed\_cidr\_blocks\_data\_priority](#input\_allowed\_cidr\_blocks\_data\_priority) | List of allowed CIDR blocks into application subnets via NACL, rule IDs have to be set manually per CIDR. Only set this after the VPC has been created | <pre>list(object({<br>    rule_id = number,<br>    cidr    = string<br>  }))</pre> | `[]` | no |
| <a name="input_append_workspace"></a> [append\_workspace](#input\_append\_workspace) | Appends the terraform workspace at the end of resource names, <identifier>-<worspace> | `bool` | `true` | no |
| <a name="input_create_private_endpoints"></a> [create\_private\_endpoints](#input\_create\_private\_endpoints) | Set to true to create private endpoints | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | A description for the VPC | `string` | `"VPC created by terraform"` | no |
| <a name="input_disable_nat_gw"></a> [disable\_nat\_gw](#input\_disable\_nat\_gw) | Set to true to disable NATs deploy, false as default | `bool` | `false` | no |
| <a name="input_flow_log_settings"></a> [flow\_log\_settings](#input\_flow\_log\_settings) | Map of VPC Flow Logs settings | <pre>object({<br>    log_destination_type     = string,<br>    enable_flow_log          = bool,<br>    traffic_type             = string,<br>    max_aggregation_interval = number,<br>    iam_role_arn             = string,<br>    flow_log_destination_arn = string,<br>    logs_retention_in_days   = number,<br>  })</pre> | <pre>{<br>  "enable_flow_log": true,<br>  "flow_log_destination_arn": null,<br>  "iam_role_arn": null,<br>  "log_destination_type": "s3",<br>  "logs_retention_in_days": null,<br>  "max_aggregation_interval": 600,<br>  "traffic_type": "ALL"<br>}</pre> | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | Name of the VPC | `string` | n/a | yes |
| <a name="input_kubernetes_tagging"></a> [kubernetes\_tagging](#input\_kubernetes\_tagging) | Set to true to enable kubernetes required tags for subnets | `bool` | `false` | no |
| <a name="input_multi_nat_gw"></a> [multi\_nat\_gw](#input\_multi\_nat\_gw) | Set to true to create a nat gateway per availability zone, symmetrical subnets are required for best performance, try to avoid different subnet count between layers | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | Region where the VPC will be deployed | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the resource | `map(any)` | `{}` | no |
| <a name="input_vpc_settings"></a> [vpc\_settings](#input\_vpc\_settings) | Map of AWS VPC settings | <pre>object({<br>    application_subnets = list(string)<br>    public_subnets      = list(string)<br>    data_subnets        = list(string)<br>    dns_hostnames       = bool,<br>    dns_support         = bool,<br>    tenancy             = string,<br>    cidr                = string<br>  })</pre> | <pre>{<br>  "application_subnets": [<br>    "172.20.16.0/22",<br>    "172.20.20.0/22"<br>  ],<br>  "cidr": "172.20.0.0/16",<br>  "data_subnets": [<br>    "172.20.8.0/22",<br>    "172.20.12.0/22"<br>  ],<br>  "dns_hostnames": true,<br>  "dns_support": true,<br>  "public_subnets": [<br>    "172.20.0.0/22",<br>    "172.20.4.0/22"<br>  ],<br>  "tenancy": "default"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_output"></a> [output](#output\_output) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contributing
If you want to contribute to this repository check all the guidelines specified [here](.github/CONTRIBUTING.md) before submitting a new PR.
