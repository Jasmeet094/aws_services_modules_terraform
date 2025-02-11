# Kubernetes Istio Module

Configuration in this directory creates the following EKS Resources.
- EKS Control Plane
- IAM Role for Control Plane
- IAM Role for Worker Nodes
- Security Groups
- Worker Nodes in AWS Manged Node Group
- Istio Stack via Helm Charts

You can choose to create an EKS setup with the following options:

- Create an EKS setup in an existing VPC:
    ```
        create_vpc = false          # Default setup
    ```
- Create an EKS setup in a new VPC: 
    This creates a new VPC in your account and then provisions EKS resources inside that VPC.
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
