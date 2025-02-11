[SourceCode](https://github.com/nclouds/terraform-aws-eks/tree/master/examples/simple)   
[Report an Issue](https://github.com/nclouds/terraform-aws-eks/issues)

# Simple EKS example

Configuration in this directory creates the following EKS Resources.
- EKS Control Plane
- IAM Role for Control Plane
- IAM Role for Worker Nodes
- Security Groups
- Worker Nodes in an AutoScaling Group

The worker nodes are created from the Latest EKS optimized AMI.
```hcl
    data "aws_ssm_parameter" "eks_ami" {
        name = "/aws/service/eks/optimized-ami/${var.eks_version}/amazon-linux-2/recommended/image_id"
    }
```

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.
