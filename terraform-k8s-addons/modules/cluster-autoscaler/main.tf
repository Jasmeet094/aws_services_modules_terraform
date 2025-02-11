locals {
  default_tags = {
    Environment = terraform.workspace
    Name        = "${var.cluster_name}-cluster-autoscaler-${data.aws_region.current.name}-${terraform.workspace}"
  }
  tags = merge(local.default_tags, var.tags)
}

resource "helm_release" "cluster_autoscaler" {
  name       = "aws-cluster-autoscaler-chart"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  version    = var.cluster_autoscaler_chart_version

  namespace        = var.cluster_autoscaler_namespace
  create_namespace = true

  values = var.cluster_autoscaler_yaml_values

  set {
    name  = "awsRegion"
    value = data.aws_region.current.name
  }

  set {
    name  = "autoDiscovery.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.cluster_autoscaler_role.output.role.arn
  }

  set {
    name  = "rbac.serviceAccount.name"
    value = "aws-cluster-autoscaler"
  }

  dynamic "set" {
    for_each = var.cluster_autoscaler_chart_values
    content {
      name  = set.key
      value = set.value
    }
  }
}

module "cluster_autoscaler_role" {
  source  = "app.terraform.io/ncodelibrary/iam-role/aws"
  version = "0.1.2"

  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:aws-cluster-autoscaler"]
  iam_policies_to_attach        = [aws_iam_policy.cluster_autoscaler.arn]
  provider_urls                 = [var.cluster_oidc_issuer_url]
  identifier                    = "${var.cluster_name}-cluster-autoscaler-${data.aws_region.current.name}"
  tags                          = local.tags
}

resource "aws_iam_policy" "cluster_autoscaler" {
  name_prefix = "cluster-autoscaler"
  description = "EKS cluster-autoscaler policy for cluster ${var.cluster_name}"
  policy      = data.aws_iam_policy_document.cluster_autoscaler.json
}

data "aws_iam_policy_document" "cluster_autoscaler" {

  statement {
    sid    = "clusterAutoscalerAll"
    effect = "Allow"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "ec2:DescribeLaunchTemplateVersions",
    ]

    resources = ["*"] #tfsec:ignore:AWS099
  }

  statement {
    sid    = "clusterAutoscalerOwn"
    effect = "Allow"

    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
    ]

    resources = ["*"] #tfsec:ignore:AWS099

    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/kubernetes.io/cluster/${var.cluster_name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/enabled"
      values   = ["true"]
    }
  }
}
