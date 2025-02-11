<p align="left"><img width=400 height="100" src="https://www.nclouds.com/img/nclouds-logo.svg"></p>  

![Terraform](https://github.com/nclouds/terraform-aws-security-group/workflows/Terraform/badge.svg)
# nCode Library

## AWS Security Group (SG) Terraform Module   
Terraform module to provision [`AWS VPC Security Group`](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html) on AWS.

## Usage

### Simple setup

Create a simple security group with default rules.
```hcl
    module "security_group" {
        source     = "github.com/nclouds/terraform-aws-security-group?ref=v0.2.10"
        identifier = "example-sg"
        vpc_id     = "vpc-xxxxxxxxxxxxx"
        tags       = {
            Owner       = "sysops"
            env         = "dev"
            Cost_Center = "XYZ"
        }
    }
```

For more details on a working example, please visit [`examples/simple`](examples/simple)

### Advanced Setup
If you want to create security group with custom rules, you can use the module like this:

```hcl
    module "security_group" {
        source     = "github.com/nclouds/terraform-aws-security-group?ref=v0.2.4"
        identifier = "example-sg"
        vpc_id     = "vpc-xxxxxxxxxxxxx"
        ingress_rule_list = [
            {
            cidr_blocks = ["0.0.0.0/0"],
            description = "HTTPS inbound",
            from_port   = 443,
            protocol    = "tcp",
            to_port     = 443
            },
            {
            cidr_blocks = ["0.0.0.0/0"],
            description = "HTTP inbound",
            from_port   = 80,
            protocol    = "tcp",
            to_port     = 80
        }]
        egress_rule_list = [{
            cidr_blocks = ["0.0.0.0/0"],
            description = "HTTPS outbound",
            from_port   = 443,
            protocol    = "tcp",
            to_port     = 443
            },
            {
            cidr_blocks = ["0.0.0.0/0"],
            description = "HTTP outbound",
            from_port   = 80,
            protocol    = "tcp",
            to_port     = 80
            }
        ]
        tags = var.tags
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
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_common_tags"></a> [common\_tags](#module\_common\_tags) | github.com/nclouds/terraform-aws-common-tags | v0.1.2 |

## Resources

| Name | Type |
|------|------|
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.default_egress_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.default_ingress_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.default_security_group_ingress_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_append_workspace"></a> [append\_workspace](#input\_append\_workspace) | Appends the terraform workspace at the end of resource names, <identifier>-<worspace> | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | A description for the security group | `string` | `"Security group created by terraform"` | no |
| <a name="input_egress_rule_list"></a> [egress\_rule\_list](#input\_egress\_rule\_list) | List of security group egress rules | <pre>list(object({<br>    cidr_blocks = list(string),<br>    description = string,<br>    from_port   = number,<br>    protocol    = string,<br>    to_port     = number<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "Default egress rule",<br>    "from_port": 0,<br>    "protocol": "all",<br>    "to_port": 65535<br>  }<br>]</pre> | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | The name of the security group | `string` | n/a | yes |
| <a name="input_ingress_from_security_group_list"></a> [ingress\_from\_security\_group\_list](#input\_ingress\_from\_security\_group\_list) | List of security group ingress rules that specify another Security Group rather than a CIDR | <pre>list(object({<br>    source_security_group_id = string,<br>    description              = string,<br>    from_port                = number,<br>    protocol                 = string,<br>    to_port                  = number<br>  }))</pre> | `[]` | no |
| <a name="input_ingress_rule_list"></a> [ingress\_rule\_list](#input\_ingress\_rule\_list) | List of security group ingress rules with a CIDR specified | <pre>list(object({<br>    cidr_blocks = list(string),<br>    description = string,<br>    from_port   = number,<br>    protocol    = string,<br>    to_port     = number<br>  }))</pre> | `[]` | no |
| <a name="input_self_rule"></a> [self\_rule](#input\_self\_rule) | Set to 'true' to create a self ingress rule in the security group | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the resource | `map(any)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The id of the VPC where the security group is being deployed | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_output"></a> [output](#output\_output) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contributing
If you want to contribute to this repository check all the guidelines specified [here](.github/CONTRIBUTING.md) before submitting a new PR.
