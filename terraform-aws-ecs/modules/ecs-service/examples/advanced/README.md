# Advanced ECS Service example

Configuration in this directory creates the following ECS Resources with Default configuration.
- ECS Cluster
- ECS Task Definitions
- ECS Service
- Application Load Balancer
- IAM Role for Tasks
- Cloudwatch Log Group
- SSM Parameter Store Entry for Secrets

You can choose to create an ECS setup with the following options:

- Create an ECS setup in an existing VPC:
    ```
        create_vpc = false          # Default setup
    ```
- Create an ECS setup in a new VPC: 
    This creates a new VPC in your account and then provisions ECS resources inside that VPC.
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
