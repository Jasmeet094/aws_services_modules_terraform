data "aws_partition" "current" {}

data "aws_subnet" "subnets_data" {
  id = var.subnets[0]
}
