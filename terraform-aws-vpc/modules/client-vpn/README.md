# Client VPN Endpoint - Terraform Module

# AWS Virtual Private Cloud Peering Connection (VPC Perring) Terraform Module

Terraform module to provision [`AWS Client VPN`](https://aws.amazon.com/vpn/client-vpn/) on AWS.

## Usage

Create a REQUESTER VPC
```hcl
    module "vpn" {
      source = "git@github.com:nclouds/terraform-aws-vpc.git//modules/client-vpn?ref=v0.5.0"

      self_service_saml_provider_arn = "arn:aws:iam::***********:saml-provider/*******"
      server_certificate_arn         = "arn:aws:acm:*******:**********:certificate/************"
      network_association            = "subnet-*********"
      saml_provider_arn              = "arn:aws:iam::***********:saml-provider/*******"
      identifier                     = var.identifier
      tags                           = var.tags

      vpn_routes                     = {
        route1: {
          destination_cidr_block = "10.10.0.0/16"
          description = "this is an example"
        }
      }
      authorization_rules            = {
        auth1: {
          target_network_cidr = "10.10.0.0/16"
          access_group_id = "some_id"
          description = "this is an example"
        }
      }
    }
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_common_tags"></a> [common\_tags](#module\_common\_tags) | github.com/nclouds/terraform-aws-common-tags?ref=v0.1.2 |  |
| <a name="module_log_group"></a> [log\_group](#module\_log\_group) | github.com/nclouds/terraform-aws-cloudwatch?ref=v0.1.17 |  |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_client_vpn_authorization_rule.internet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_authorization_rule) | resource |
| [aws_ec2_client_vpn_authorization_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_authorization_rule) | resource |
| [aws_ec2_client_vpn_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_endpoint) | resource |
| [aws_ec2_client_vpn_network_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_network_association) | resource |
| [aws_ec2_client_vpn_route.internet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_route) | resource |
| [aws_ec2_client_vpn_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_route) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_append_workspace"></a> [append\_workspace](#input\_append\_workspace) | Appends the terraform workspace at the end of resource names, <identifier>-<worspace> | `bool` | `true` | no |
| <a name="input_authorization_rules"></a> [authorization\_rules](#input\_authorization\_rules) | Authorization rules for AWS Client VPN endpoints | <pre>map(object({<br>    target_network_cidr : string<br>    access_group_id : string<br>    description : string<br>  }))</pre> | `{}` | no |
| <a name="input_client_cidr_block"></a> [client\_cidr\_block](#input\_client\_cidr\_block) | The IPv4 address range, in CIDR notation, from which to assign client IP addresses | `string` | `"10.254.0.0/22"` | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | Identifier for all resources | `string` | n/a | yes |
| <a name="input_internet_access_enabled"></a> [internet\_access\_enabled](#input\_internet\_access\_enabled) | Enable internet access route through the VPN | `bool` | `true` | no |
| <a name="input_logs_enabled"></a> [logs\_enabled](#input\_logs\_enabled) | Enable vpn logs to CloudWatch | `bool` | `true` | no |
| <a name="input_network_association"></a> [network\_association](#input\_network\_association) | The ID of the subnet to associate with the Client VPN endpoint | `string` | n/a | yes |
| <a name="input_saml_provider_arn"></a> [saml\_provider\_arn](#input\_saml\_provider\_arn) | The ARN of the IAM SAML identity provider | `string` | n/a | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | The IDs of one or more security groups to apply to the target network | `list(string)` | `null` | no |
| <a name="input_self_service_saml_provider_arn"></a> [self\_service\_saml\_provider\_arn](#input\_self\_service\_saml\_provider\_arn) | The ARN of the IAM SAML identity provider for the self service portal | `string` | n/a | yes |
| <a name="input_server_certificate_arn"></a> [server\_certificate\_arn](#input\_server\_certificate\_arn) | The ARN of the ACM server certificate | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the resource | `map(any)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC to associate with the Client VPN endpoint | `string` | `null` | no |
| <a name="input_vpn_routes"></a> [vpn\_routes](#input\_vpn\_routes) | List of routes to add to the VPN | <pre>map(object({<br>    destination_cidr_block : string<br>    description : string<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_output"></a> [output](#output\_output) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contributing
If you want to contribute to this repository check all the guidelines specified [here](.github/CONTRIBUTING.md) before submitting a new PR.
