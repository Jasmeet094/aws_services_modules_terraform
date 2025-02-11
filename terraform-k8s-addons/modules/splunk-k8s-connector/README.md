## splunk connect for kubernetes official github url
https://github.com/splunk/splunk-connect-for-kubernetes

## Resources

| Name | Type |
|------|------|
| [helm_release.splunk-k8s-connector](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_helm_chart_version"></a> [helm\_chart\_version](#input\_helm\_chart\_version) | Version of the splunk-k8s-connector Helm chart to use | `string` | `"1.4.7"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | namespace to deploy splunk-k8s-connector helm charts | `string` | `"splunk-k8s"` | no |
| <a name="input_splunk_hec_token"></a> [splunk\_hec\_token](#input\_splunk\_hec\_token) | provide hec token for splunk | `string` | n/a | yes |
| <a name="input_values_file_path"></a> [values\_file\_path](#input\_values\_file\_path) | helm chart values file path for perticular env | `string` | n/a | yes |

## Outputs

No outputs.