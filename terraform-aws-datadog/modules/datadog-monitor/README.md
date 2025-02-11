# datadog-monitor

Terraform submodule for DataDog monitor.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |
| <a name="requirement_datadog"></a> [datadog](#requirement\_datadog) | 2.16.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_datadog"></a> [datadog](#provider\_datadog) | 2.16.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_common_tags"></a> [common\_tags](#module\_common\_tags) | github.com/nclouds/terraform-aws-common-tags | v0.1.2 |

## Resources

| Name | Type |
|------|------|
| [datadog_monitor.monitors](https://registry.terraform.io/providers/DataDog/datadog/2.16.0/docs/resources/monitor) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable"></a> [enable](#input\_enable) | Tag to enable disable monitors creation | `bool` | `false` | no |
| <a name="input_include_tags"></a> [include\_tags](#input\_include\_tags) | Option for setting up tag inclusion in monitor title while triggering. | `bool` | `true` | no |
| <a name="input_message"></a> [message](#input\_message) | Initial message to add in monitor | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The title/name of monitor | `string` | n/a | yes |
| <a name="input_new_host_delay"></a> [new\_host\_delay](#input\_new\_host\_delay) | Delay evaluation for new host. | `number` | `300` | no |
| <a name="input_no_data_timeframe"></a> [no\_data\_timeframe](#input\_no\_data\_timeframe) | Timeframe for no dfata notification. | `number` | `20` | no |
| <a name="input_notify_audit"></a> [notify\_audit](#input\_notify\_audit) | Set true to get notification on monitor modification. | `bool` | `false` | no |
| <a name="input_notify_no_data"></a> [notify\_no\_data](#input\_notify\_no\_data) | No data notification | `bool` | `true` | no |
| <a name="input_query"></a> [query](#input\_query) | The monitor query | `string` | n/a | yes |
| <a name="input_renotify_interval"></a> [renotify\_interval](#input\_renotify\_interval) | Interval for renotification if monitor is in triggered state. | `number` | `90` | no |
| <a name="input_require_full_window"></a> [require\_full\_window](#input\_require\_full\_window) | Option for setting full window evaluation for datadog monitor. | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Add values to set tags for monitor. | `map(any)` | `{}` | no |
| <a name="input_thresholds"></a> [thresholds](#input\_thresholds) | warning,critical,ok thresholds | `map(any)` | `{}` | no |
| <a name="input_type"></a> [type](#input\_type) | Defining monitor type | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_output"></a> [output](#output\_output) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contributing
If you want to contribute to this repository check all the guidelines specified [here](.github/CONTRIBUTING.md) before submitting a new PR.
