<p align="left"><img width=400 height="100" src="https://www.nclouds.com/img/nclouds-logo.svg"></p>  

![Terraform](https://github.com/nclouds/terraform-aws-sqs/workflows/Terraform/badge.svg)
# nCode Library

## terraform-aws-sqs

Terraform module to provision [`Simple Queues`](https://aws.amazon.com/sqs/) on AWS.

## Usage

### Simple setup
Create a simple SQS Queue:

```hcl
module "sqs" {
  source             = "git@github.com:nclouds/terraform-aws-sqs.git?ref=v0.2.10"
  identifier         = "example"
  tags               = {
    Cost_Center = "XYZ"
  }
}
```

For more details on a working example, please visit [`examples/simple`](examples/simple)

### Advanced setup
Create a SNS Topic:
resource "aws_sns_topic" "topic" {
  name = "example"
}

Create a SQS Queue with a Resource Policy:

data "aws_iam_policy_document" "sqs" {
  statement {
    sid    = "SQSSendMessage"
    effect = "Allow"
    actions = [
      "sqs:SendMessage",
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::<account_id>:root"]
    }
    resources = ["*"]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = ["${aws_sns_topic.topic.arn}"]
    }

  }
}

```hcl
module "sqs" {
  source                        = "git@github.com:nclouds/terraform-aws-sqs.git?ref=v0.2.7"
  identifier                    = var.identifier
  dead_letter_queue             = true
  delay_seconds                 = 60
  message_retention_seconds     = 86400
  message_retention_seconds_dlq = 86400
  max_receive_count             = 1
  content_based_deduplication   = true
  policy = data.aws_iam_policy_document.sqs.json
  fifo_queue = true
  tags               = {
    Cost_Center = "XYZ"
  }
}
```

For more details on a working example, please visit [`examples/simple`](examples/simple)

## Examples
Here are some working examples of using this module:
- [`examples/simple`](examples/simple)
- [`examples/advanced`](examples/advanced)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.50.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.50.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_common_tags"></a> [common\_tags](#module\_common\_tags) | github.com/nclouds/terraform-aws-common-tags.git | v0.1.2 |

## Resources

| Name | Type |
|------|------|
| [aws_sqs_queue.dead_letter_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_append_workspace"></a> [append\_workspace](#input\_append\_workspace) | Appends the terraform workspace at the end of resource names, <identifier>-<worspace> | `bool` | `true` | no |
| <a name="input_content_based_deduplication"></a> [content\_based\_deduplication](#input\_content\_based\_deduplication) | Enables content-based deduplication for FIFO queues | `bool` | `false` | no |
| <a name="input_dead_letter_queue"></a> [dead\_letter\_queue](#input\_dead\_letter\_queue) | set to 'true' to deploy a DeadLetterQueue | `bool` | `false` | no |
| <a name="input_delay_seconds"></a> [delay\_seconds](#input\_delay\_seconds) | The time in seconds that the delivery of all messages in the queue will be delayed | `number` | `90` | no |
| <a name="input_fifo_queue"></a> [fifo\_queue](#input\_fifo\_queue) | Boolean designating a FIFO queue, defaults to a standard queue | `bool` | `false` | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | The identifier for the resources | `string` | n/a | yes |
| <a name="input_kms_master_key_id"></a> [kms\_master\_key\_id](#input\_kms\_master\_key\_id) | The ID of an AWS-managed customer master key | `string` | `"alias/aws/sqs"` | no |
| <a name="input_max_message_size"></a> [max\_message\_size](#input\_max\_message\_size) | The limit of how many bytes a message can contain before Amazon SQS rejects it | `number` | `2048` | no |
| <a name="input_max_receive_count"></a> [max\_receive\_count](#input\_max\_receive\_count) | Max number of times a message can be received before it gets put in the Dead Letter Queue | `number` | `5` | no |
| <a name="input_message_retention_seconds"></a> [message\_retention\_seconds](#input\_message\_retention\_seconds) | The number of seconds Amazon SQS retains a message | `number` | `345600` | no |
| <a name="input_message_retention_seconds_dlq"></a> [message\_retention\_seconds\_dlq](#input\_message\_retention\_seconds\_dlq) | The number of seconds Amazon SQS retains a message in the Dead Letter Queue | `number` | `345600` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | The JSON policy for the SQS queue | `string` | `null` | no |
| <a name="input_receive_wait_time_seconds"></a> [receive\_wait\_time\_seconds](#input\_receive\_wait\_time\_seconds) | The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning | `number` | `10` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the resource | `map(any)` | `{}` | no |
| <a name="input_visibility_timeout_seconds"></a> [visibility\_timeout\_seconds](#input\_visibility\_timeout\_seconds) | The visibility timeout for the queue. An integer from 0 to 43200 (12 hours) | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_output"></a> [output](#output\_output) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contributing
If you want to contribute to this repository check all the guidelines specified [here](.github/CONTRIBUTING.md) before submitting a new PR.
