[SourceCode](https://github.com/nclouds/terraform-aws-alb/tree/master/examples/advanced)   
[Report an Issue](https://github.com/nclouds/terraform-aws-alb/issues)

# Advanced ALB example

Configuration in this directory creates the following Resources:
- Application Load Balancer
- Security Group for ALB
- A Certificate in AWS Certificate Manager

Note: The example assumes that you already have a domain regietered and a Hosted Zone Created in the account.

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

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.
