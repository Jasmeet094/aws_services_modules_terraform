[SourceCode](https://github.com/nclouds/terraform-aws-eks/tree/master/examples/bottlerocket)   
[Report an Issue](https://github.com/nclouds/terraform-aws-eks/issues)

# Bottlerocket EKS example
Configuration in this directory creates the following EKS Resources.
- EKS Control Plane
- IAM Role for Control Plane
- IAM Role for Worker Nodes
- Security Groups
- Worker Nodes in an AutoScaling Group

The worker nodes are created from the Latest BottleRocket AMI for EKS.
```hcl
    data "aws_ssm_parameter" "eks_ami" {
    name = "/aws/service/bottlerocket/aws-k8s-${var.eks_version}/x86_64/latest/image_id"
    }
```

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
