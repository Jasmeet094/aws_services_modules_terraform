locals {
  default_tags = {
    Environment = terraform.workspace
    Name        = "${var.cluster_name}-${terraform.workspace}"
  }
  tags = merge(local.default_tags, var.tags)
}

resource "helm_release" "nginx_ingress" {
  name = "nginx-ingress-controller"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"
  version    = var.nginx_ingress_controller_chart_version

  namespace        = "nginx-ingress"
  create_namespace = true

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.nginx_ingress_controller_role.output.role.arn
  }

  dynamic "set" {
    for_each = var.nginx_ingress_controller_values
    content {
      name  = set.value["name"]
      value = set.value["value"]
    }
  }
}

module "nginx_ingress_controller_role" {
  source  = "app.terraform.io/ncodelibrary/iam-role/aws"
  version = "0.1.2"

  oidc_fully_qualified_subjects = ["system:serviceaccount:nginx-ingress:nginx-ingress-controller"]
  iam_policies_to_attach        = [aws_iam_policy.nginx_ingress_controller.arn]
  provider_urls                 = [var.cluster_oidc_issuer_url]
  identifier                    = "${var.cluster_name}-nginx_ingress_controller-${data.aws_region.current.name}"
  tags                          = local.tags
}

resource "aws_iam_policy" "nginx_ingress_controller" {
  name_prefix = "nginx_ingress_controller"
  description = "EKS nginx_ingress_controller policy for cluster ${var.cluster_name}"
  policy      = data.aws_iam_policy_document.nginx_ingress_controller.json
}

data "aws_iam_policy_document" "nginx_ingress_controller" {

  statement {
    sid    = "loadBalancerAll"
    effect = "Allow"

    actions = [ #tfsec:ignore:AWS099
      "elasticloadbalancing:*",
      "ec2:Describe*"
    ]

    resources = ["*"] #tfsec:ignore:AWS099
  }
}