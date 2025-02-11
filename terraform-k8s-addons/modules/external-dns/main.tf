locals {
  default_tags = {
    Environment = terraform.workspace
    Name        = "${var.cluster_name}-cluster-autoscaler-${data.aws_region.current.name}-${terraform.workspace}"
  }
  tags = merge(local.default_tags, var.tags)
}

resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = var.external_dns_chart_version

  namespace        = var.external_dns_namespace
  create_namespace = true

  values = var.external_dns_yaml_values

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.external_dns_role.output.role.arn
  }

  dynamic "set" {
    for_each = var.external_dns_chart_values
    content {
      name  = set.key
      value = set.value
    }
  }
}

module "external_dns_role" {
  source  = "app.terraform.io/ncodelibrary/iam-role/aws"
  version = "0.1.2"

  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:external-dns"]
  iam_policies_to_attach        = [aws_iam_policy.external_dns.arn]
  provider_urls                 = [var.cluster_oidc_issuer_url]
  identifier                    = "${var.cluster_name}-external-dns-${data.aws_region.current.name}"
  tags                          = local.tags
}

resource "aws_iam_policy" "external_dns" {

  name_prefix = "external-dns"
  description = "EKS external-dns policy for cluster ${var.cluster_name}"
  policy      = data.aws_iam_policy_document.external_dns.json
}

data "aws_iam_policy_document" "external_dns" {

  statement {
    effect = "Allow"
    actions = [
      "route53:ChangeResourceRecordSets",
    ]
    resources = length(var.external_dns_hosted_zone_ids) > 0 ? [for zone_id in var.external_dns_hosted_zone_ids : "arn:aws:route53:::hostedzone/${zone_id}"] : ["arn:aws:route53:::hostedzone/*"] #tfsec:ignore:AWS099
  }

  statement {
    effect = "Allow"
    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
    ]
    resources = ["*"] #tfsec:ignore:AWS099
  }
}
