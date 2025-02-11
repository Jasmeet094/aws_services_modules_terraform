# Simple EKS Fargate profile Example

Configuration in this directory creates the following ECS Resources.
- EKS Cluster
- EKS Fargate Profile
- IAM Role for Worker Nodes

You can choose to create an EKS setup with the following options:

- Create an EKS setup in an existing VPC:
    ```
        create_vpc = false          # Default setup
    ```
- Create an EKS setup in a new VPC: 
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
