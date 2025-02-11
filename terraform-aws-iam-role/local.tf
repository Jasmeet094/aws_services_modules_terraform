locals {
  urls = [
    for url in compact(distinct(var.provider_urls)) :
    replace(url, "https://", "")
  ]

  assume_role_policy = length(var.oidc_fully_qualified_subjects) > 0 ? data.aws_iam_policy_document.oidc[0].json : data.aws_iam_policy_document.default[0].json
}