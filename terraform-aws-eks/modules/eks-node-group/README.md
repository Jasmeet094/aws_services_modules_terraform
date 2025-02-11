# terraform-aws-eks-node-group

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
| [aws_eks_node_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_launch_template.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_type"></a> [ami\_type](#input\_ami\_type) | Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Valid values: AL2\_x86\_64, AL2\_x86\_64\_GPU, AL2\_ARM\_64 | `string` | `"AL2_x86_64"` | no |
| <a name="input_append_workspace"></a> [append\_workspace](#input\_append\_workspace) | Appends the terraform workspace at the end of resource names, <identifier>-<worspace> | `bool` | `true` | no |
| <a name="input_block_device_mappings"></a> [block\_device\_mappings](#input\_block\_device\_mappings) | List of block device mappings for the launch template.<br>Each list element is an object with a `device_name` key and<br>any keys supported by the `ebs` block of `launch_template`. | `list(any)` | <pre>[<br>  {<br>    "delete_on_termination": true,<br>    "device_name": "/dev/xvda",<br>    "encrypted": true,<br>    "volume_size": 20,<br>    "volume_type": "gp2"<br>  }<br>]</pre> | no |
| <a name="input_capacity_type"></a> [capacity\_type](#input\_capacity\_type) | Type of capacity associated with the EKS Node Group. Valid values: ON\_DEMAND, SPOT | `string` | `"ON_DEMAND"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS Cluster | `string` | n/a | yes |
| <a name="input_desired_size"></a> [desired\_size](#input\_desired\_size) | Desired number of worker nodes | `number` | `1` | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | The name for the cluster | `string` | n/a | yes |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | Set of instance types associated with the EKS Node Group | `list(string)` | <pre>[<br>  "t3.medium"<br>]</pre> | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Key-value map of Kubernetes labels | `map(string)` | `{}` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Maximum number of worker nodes | `number` | `1` | no |
| <a name="input_metadata_options"></a> [metadata\_options](#input\_metadata\_options) | The metadata options for the instances | `map(string)` | <pre>{<br>  "http_endpoint": "enabled",<br>  "http_put_response_hop_limit": "1",<br>  "http_tokens": "required"<br>}</pre> | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Minimum number of worker nodes | `number` | `1` | no |
| <a name="input_node_role_arn"></a> [node\_role\_arn](#input\_node\_role\_arn) | Amazon Resource Name (ARN) of the IAM Role that provides permissions for the EKS Node Group | `string` | n/a | yes |
| <a name="input_ssm_agent_enabled"></a> [ssm\_agent\_enabled](#input\_ssm\_agent\_enabled) | Install the SSM agent on the worker nodes (requires proper IAM permissions to be set on the attached IAM Role) | `string` | `true` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Identifiers of EC2 Subnets to associate with the EKS Node Group, must have the required tags | `list(string)` | n/a | yes |
| <a name="input_tag_resource_types"></a> [tag\_resource\_types](#input\_tag\_resource\_types) | List of resource types to tag | `list(string)` | <pre>[<br>  "spot-instances-request",<br>  "elastic-gpu",<br>  "instance",<br>  "volume"<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to all resources | `map(any)` | `{}` | no |
| <a name="input_taints"></a> [taints](#input\_taints) | The Kubernetes taints to be applied to the nodes in the node group | <pre>list(object({<br>    effect = string<br>    value  = string<br>    key    = string<br>  }))</pre> | `[]` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | A list of security group IDs to associate with | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_output"></a> [output](#output\_output) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## Contributing
If you want to contribute to this repository check all the guidelines specified [here](.github/CONTRIBUTING.md) before submitting a new PR.
