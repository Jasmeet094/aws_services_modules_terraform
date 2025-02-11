<p align="left"><img width=400 height="100" src="https://www.nclouds.com/img/nclouds-logo.svg"></p>  

![Terraform](https://github.com/nclouds/terraform-aws-route53-record/workflows/Terraform/badge.svg)
# nCode Library

## AWS Route53 (DNS) Terraform Module

Terraform module to provision [`Route53 DNS records`](https://aws.amazon.com/route53) on AWS.

## Usage

### Simple setup

Create a simple Route53 DNS CNAME Record.
```hcl
    module "record" {
        source      = "git@github.com:nclouds/terraform-aws-route53-record.git?ref=v0.1.10"
        domain_name = "ncodelibrary.com"
        records     = ["something.example.com"]
        name        = "example"
        type        = "CNAME"
        ttl         = 300
    }   
```

For more details on a working example, please visit [`examples/simple`](examples/simple)

### Advanced Setup
If you want to create Route53 DNS Record with enhanced configuration e.g alias to other AWS Service etc., you can use the module like this:

```hcl
    module "record" {
        source      = "git@github.com:nclouds/terraform-aws-route53-record.git?ref=v0.1.10"
        domain_name = "ncodelibrary.com"
        alias = [{
            evaluate_target_health = true,
            zone_id                = "Z1H1xxxxxxxx",
            name                   = "dualstack.some-alb.some-region.elb.amazonaws.com."
        }]
        name = "example"
        type = "CNAME"
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
| terraform | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alias | n/a | <pre>list(object({<br>    evaluate_target_health = bool,<br>    zone_id                = string,<br>    name                   = string<br>  }))</pre> | `[]` | no |
| domain\_name | The name of the hosted zone to use | `string` | n/a | yes |
| name | The name of the record | `string` | n/a | yes |
| private\_zone | Whether this is a private hosted zone or not (defaults to false) | `bool` | `false` | no |
| records | (Required for non-alias records) A string list of records | `list(string)` | `null` | no |
| ttl | (Required for non-alias records) The TTL of the record | `number` | `null` | no |
| type | The record type. Valid values are A, AAAA, CAA, CNAME, MX, NAPTR, NS, PTR, SOA, SPF, SRV and TXT | `string` | `"A"` | no |

## Outputs

| Name | Description |
|------|-------------|
| output | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contributing
If you want to contribute to this repository check all the guidelines specified [here](.github/CONTRIBUTING.md) before submitting a new PR.
