resource "aws_db_proxy" "db_proxy" {
  vpc_security_group_ids = var.db_proxy_sg
  idle_client_timeout    = var.idle_client_timeout
  vpc_subnet_ids         = var.db_proxy_subnets
  engine_family          = var.db_engine
  debug_logging          = var.debug_logging
  require_tls            = var.require_tls
  role_arn               = aws_iam_role.db_role.arn
  name                   = local.identifier
  auth {
    auth_scheme = "SECRETS"
    secret_arn  = var.db_secret_arn
    iam_auth    = var.iam_auth
  }
  tags = local.tags
}
# Create Target Group for rds proxy
resource "aws_db_proxy_default_target_group" "default_target" {
  db_proxy_name = aws_db_proxy.db_proxy.name
  connection_pool_config {
    max_idle_connections_percent = var.max_idle_connections_percent
    connection_borrow_timeout    = var.connection_borrow_timeout
    max_connections_percent      = var.max_connections_percent
    session_pinning_filters      = var.session_pinning_filters
    init_query                   = var.init_query
  }
}
# Define rds proxy target
resource "aws_db_proxy_target" "target" {
  db_instance_identifier = var.db_instance_identifier
  target_group_name      = aws_db_proxy_default_target_group.default_target.name
  db_proxy_name          = local.identifier
}
# Create Iam role with secret access
resource "aws_iam_role" "db_role" {
  name = "rds_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "rds.amazonaws.com"
        }
      },
    ]
  })
  tags = local.tags
}
# Create Policy
#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_policy" "policy" {
  name = "rds_proxy_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["secretsmanager:GetRandomPassword", "secretsmanager:CreateSecret", "secretsmanager:ListSecrets"]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = ["secretsmanager:*"]
        Effect   = "Allow"
        Resource = "${var.db_secret_arn}"
      },
    ]
  })
}
# Attach policy to the role
resource "aws_iam_role_policy_attachment" "policy_attach" {
  role       = aws_iam_role.db_role.name
  policy_arn = aws_iam_policy.policy.arn
}


