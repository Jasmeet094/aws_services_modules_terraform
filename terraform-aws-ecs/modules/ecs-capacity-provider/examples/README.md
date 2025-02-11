# Simple ECS Capacity provider example

Configuration in this directory creates the following ECS Resources.
- ECS Cluster
- ECS Capacity provider
- IAM Role for ECS Hosts
- Security Groups
- AutoScaling Group for ECS Hosts
- Attach ECS Capacity provider with Autoscaling Group and ECS Cluster

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
