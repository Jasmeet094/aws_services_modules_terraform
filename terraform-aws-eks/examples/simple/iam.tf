# IAM ROLE for Workers
module "worker_role" {
  source = "github.com/nclouds/terraform-aws-iam-role?ref=v1.0.2"
  iam_policies_to_attach = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
  trusted_service_arns = ["ec2.amazonaws.com"]
  identifier           = "${var.identifier}-worker"
}
