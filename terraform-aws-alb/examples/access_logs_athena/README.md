[SourceCode](https://github.com/nclouds/terraform-aws-alb/tree/master/examples/access_logs_athena)   
[Report an Issue](https://github.com/nclouds/terraform-aws-alb/issues)

# ALB Access logs and athena integration example

Configuration in this directory creates the following Resources:
- Application Load Balancer
- Security Group for ALB
- S3 Bucket
- IAM policy and role
- Athena DB and table

You can choose to create an ALB setup with the following options:

- Create an ALB setup in an existing VPC:
    ```
        create_vpc = false          # Default setup
    ```
- Create an ALB setup in a new VPC: 
    This creates a new VPC in your account and then provisions ALB resources inside that VPC.
    ```
        create_vpc = true
    ```
- Enable access logs option
    ```
        alb_access_logs_enable = true
    ```
- Create a new bucket to store logs if the value is an empty string, if not uses the specified bucket
    ```
        bucket_name = ""
    ```
- Prefix which the logs will be stored with on the s3 bucket
    ```
        bucket_logs_prefix = "example"
    ```
- Activate Athena integration
    ```
        athena_integration     = true
    ```

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.
