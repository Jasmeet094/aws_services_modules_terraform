<p align="left"><img width=400 height="100" src="https://www.nclouds.com/img/nclouds-logo.svg"></p>  

![Terraform](https://github.com/nclouds/terraform-aws-lambda/workflows/Terraform/badge.svg)
# nCode Library

## AWS LAMBDA Terraform Module

Terraform module to provision [`Lambda Functions`](https://aws.amazon.com/lambda/) on AWS.

## Usage

### Simple setup

Create a simple Lambda Function with default configurations.
```hcl
    module "function" {
        source           = "git@github.com:nclouds/terraform-aws-lambda.git?ref=v0.2.2"
        identifier       = "example-function"
        iam_role         = "arn:aws:iam::XXXXXXXX:role/XXXXXXX"
        handler          = "lambda_function.lambda_handler"
        runtime          = "python3.7"
        s3_bucket        = "example-default"
        s3_key           = "lambda_function.zip"
        source_code_hash = "vIBhQhmMUkvbKhUr3FaUm51UproR7zRAKhg4RFAgfAw="
        tags             = {
            Owner       = "sysops"
            env         = "dev"
            Cost_Center = "XYZ"
        }
        environment      = {
            SUBJECT = "nClouds"
        }
    }   
```

For more details on a working example, please visit [`examples/simple`](examples/simple)

### Advanced Setup
If you want to create a Lambda Function with enhanced configuration e.g in a VPC, with event triggers, custom layers etc., you can use the module like this:

```hcl
    module "function" {
        source           = "git@github.com:nclouds/terraform-aws-lambda.git?ref=v0.2.2"
        identifier       = "example-function"
        iam_role         = "arn:aws:iam::XXXXXXXX:role/XXXXXXX"
        handler          = "lambda_function.lambda_handler"
        runtime          = "python3.7"
        s3_bucket        = "example-default"
        s3_key           = "lambda_function.zip"
        source_code_hash = "vIBhQhmMUkvbKhUr3FaUm51UproR7zRAKhg4RFAgfAw="
        tags             = {
            Owner       = "sysops"
            env         = "dev"
            Cost_Center = "XYZ"
        }
        environment      = {
            SUBJECT = "nClouds"
        }
        layers                = ["arn:aws:lambda:us-east-1:XXXXX:layer:python_requests:2"]
        event_source_arn      = "arn:aws:sqs:us-east-1:XXXXXXXX:example-default"
        create_trigger        = true
        log_retention_in_days = 30
        memory_size           = 256
        timeout               = 30
        security_group_ids    = [sg-xxxxxxxxx]
        subnet_ids            = ["subnet-xxxxxxxxxxx", "subnet-xxxxxxxxxx"]
    }
```

### Local Code Setup
If you want to create a Lambda Function specifying the location of a local zip file containing the source code, you can use the module like this:

```hcl
    data "archive_file" "lambda" {
        type        = "zip"
        source_file = "src/main.py"
        output_path = "/tmp/lambda_function_code.zip"
    }

    module "function" {
        source           = "git@github.com:nclouds/terraform-aws-lambda.git?ref=v0.2.2"
        identifier       = "example-function"
        iam_role         = "arn:aws:iam::XXXXXXXX:role/XXXXXXX"
        handler          = "lambda_function.lambda_handler"
        runtime          = "python3.7"

        filename         = "/tmp/lambda_function_code.zip"
        source_code_hash = data.archive_file.lambda.output_base64sha256

        tags             = {
            Owner       = "sysops"
            env         = "dev"
            Cost_Center = "XYZ"
        }
        environment      = {
            SUBJECT = "nClouds"
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
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.50.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.50.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_common_tags"></a> [common\_tags](#module\_common\_tags) | github.com/nclouds/terraform-aws-common-tags.git?ref=v0.1.2 |  |
| <a name="module_log_group"></a> [log\_group](#module\_log\_group) | github.com/nclouds/terraform-aws-cloudwatch.git?ref=v0.1.18 |  |

## Resources

| Name | Type |
|------|------|
| [aws_lambda_event_source_mapping.trigger](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping) | resource |
| [aws_lambda_function.function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_append_workspace"></a> [append\_workspace](#input\_append\_workspace) | Appends the terraform workspace at the end of resource names, <identifier>-<worspace> | `bool` | `true` | no |
| <a name="input_create_trigger"></a> [create\_trigger](#input\_create\_trigger) | Set to true if you specify 'event\_source\_arn' parameter | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of what your Lambda Function does | `string` | `"Deployed by terraform"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | A map that defines environment variables for the Lambda function | `map(any)` | `{}` | no |
| <a name="input_event_source_arn"></a> [event\_source\_arn](#input\_event\_source\_arn) | The event source ARN - can be a Kinesis stream, DynamoDB stream, or SQS queue. If specified set 'create\_trigger' parameter to true | `string` | `null` | no |
| <a name="input_filename"></a> [filename](#input\_filename) | Path to the function's deployment package within the local filesystem. | `string` | `null` | no |
| <a name="input_handler"></a> [handler](#input\_handler) | The function entrypoint in your code | `string` | n/a | yes |
| <a name="input_iam_role"></a> [iam\_role](#input\_iam\_role) | IAM role attached to the Lambda Function | `string` | n/a | yes |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | The name of the security group | `string` | n/a | yes |
| <a name="input_layers"></a> [layers](#input\_layers) | List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function | `list(string)` | `[]` | no |
| <a name="input_log_group_kms_key_id"></a> [log\_group\_kms\_key\_id](#input\_log\_group\_kms\_key\_id) | The ARN of the KMS Key to use when encrypting log data | `string` | `null` | no |
| <a name="input_log_group_use_custom_kms_key"></a> [log\_group\_use\_custom\_kms\_key](#input\_log\_group\_use\_custom\_kms\_key) | Set to 'true' if you are passing a custom KMS Key ARN | `bool` | `false` | no |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | Specifies the number of days you want to retain log | `number` | `14` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Amount of memory in MB your Lambda Function can use at runtime | `number` | `128` | no |
| <a name="input_publish"></a> [publish](#input\_publish) | Whether to publish creation/change as new Lambda Function Version | `bool` | `false` | no |
| <a name="input_reserved_concurrent_executions"></a> [reserved\_concurrent\_executions](#input\_reserved\_concurrent\_executions) | The amount of reserved concurrent executions for this lambda function | `number` | `-1` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | n/a | `string` | n/a | yes |
| <a name="input_s3_bucket"></a> [s3\_bucket](#input\_s3\_bucket) | The S3 bucket location containing the function's deployment package | `string` | `null` | no |
| <a name="input_s3_key"></a> [s3\_key](#input\_s3\_key) | The S3 key of an object containing the function's deployment package | `string` | `null` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | A list of security group IDs associated with the Lambda function | `list(string)` | `[]` | no |
| <a name="input_sns_topic_arn"></a> [sns\_topic\_arn](#input\_sns\_topic\_arn) | sns topic arn to send dead letter queue. Be aware that the function role will need Push permissions to the topic. | `string` | `null` | no |
| <a name="input_source_code_hash"></a> [source\_code\_hash](#input\_source\_code\_hash) | Used to trigger updates. Must be set to a base64-encoded SHA256 hash of the package file specified | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of subnet IDs associated with the Lambda function | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the resource | `map(any)` | `{}` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | The amount of time your Lambda Function has to run in seconds | `number` | `3` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_output"></a> [output](#output\_output) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contributing
If you want to contribute to this repository check all the guidelines specified [here](.github/CONTRIBUTING.md) before submitting a new PR.
