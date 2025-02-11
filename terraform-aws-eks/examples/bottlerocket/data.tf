data "aws_ssm_parameter" "eks_ami" {
  name = "/aws/service/bottlerocket/aws-k8s-1.21/x86_64/latest/image_id"
}