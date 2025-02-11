# IAM Policies

data "aws_iam_policy_document" "openvpn_assume_role" {
  statement {
    principals {
      identifiers = [
        "ec2.amazonaws.com",
        "ssm.amazonaws.com"
      ]
      type = "Service"
    }

    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]
  }
}

data "aws_iam_policy_document" "openvpn_ec2" {
  statement {
    actions = [
      "ec2:DescribeAddresses",
      "ec2:AssociateAddress",
      "ec2:AllocateAddress",
    ]

    resources = ["*"] #tfsec:ignore:AWS099
    effect    = "Allow"
  }

  statement {
    actions = [
      "ec2:ModifyInstanceAttribute",
      "ec2:DescribeTags",
    ]

    resources = ["*"] #tfsec:ignore:AWS099
    effect    = "Allow"
    condition {
      test     = "StringEquals"
      variable = "ec2:ResourceTag/Name"
      values   = ["EC2-VPN-${var.environment}"]
    }
  }

  statement {
    actions = [
      "route53:ChangeResourceRecordSets"
    ]

    resources = ["arn:aws:route53:::hostedzone/${var.hosted_zone_id}"]
    effect    = "Allow"
  }
}

resource "aws_iam_role" "openvpn_role" {
  name               = "IAM-VPN-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.openvpn_assume_role.json
  tags = merge({
    Name = "IAM-VPN-${var.environment}"
  }, local.tags)
}

resource "aws_iam_policy" "openvpn_policy" {
  name        = "IAM-VPN-${var.environment}"
  description = "Allows the openvpn server to modify itself"
  policy      = data.aws_iam_policy_document.openvpn_ec2.json
  tags = merge({
    Name = "IAM-VPN-${var.environment}"
  }, local.tags)
}

resource "aws_iam_instance_profile" "openvpn_profile" {
  name = "IAM-VPN-${var.environment}"
  role = aws_iam_role.openvpn_role.name
  tags = merge({
    Name = "IAM-VPN-${var.environment}"
  }, local.tags)
}

resource "aws_iam_role_policy_attachment" "openvpn_attach" {
  role       = aws_iam_role.openvpn_role.name
  policy_arn = aws_iam_policy.openvpn_policy.arn
}

resource "aws_iam_role_policy_attachment" "ssm_attach_ssm" {
  role       = aws_iam_role.openvpn_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ssm_attach_ec2_role" {
  role       = aws_iam_role.openvpn_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "ssm_attach_clw_agent" {
  role       = aws_iam_role.openvpn_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "ssm_attach_clw_logs" {
  role       = aws_iam_role.openvpn_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}
