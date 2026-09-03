# IAM role assumed by GitHub Actions deploy workflows via OIDC.

data "aws_iam_policy_document" "github_actions_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [local.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # Exact-match on the environment this role belongs to — not a bare
    # wildcard. Without this, the role could be assumed from any branch or
    # GitHub environment in the repo, not just this one.
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["${var.github_oidc_sub}:environment:${var.github_environment}"]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name               = "${var.environment}-sales-funnel-fe-github-actions"
  assume_role_policy = data.aws_iam_policy_document.github_actions_trust.json
}

data "aws_iam_policy_document" "s3_sync" {
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucket",
    ]
    resources = [
      aws_s3_bucket.site.arn,
      "${aws_s3_bucket.site.arn}/*",
    ]
  }
}

resource "aws_iam_role_policy" "s3_sync" {
  name   = "s3-sync"
  role   = aws_iam_role.github_actions.id
  policy = data.aws_iam_policy_document.s3_sync.json
}

data "aws_iam_policy_document" "cloudfront_invalidation" {
  statement {
    effect = "Allow"
    actions = [
      "cloudfront:CreateInvalidation",
      "cloudfront:GetInvalidation",
    ]
    resources = [aws_cloudfront_distribution.site.arn]
  }
}

resource "aws_iam_role_policy" "cloudfront_invalidation" {
  name   = "cloudfront-invalidation"
  role   = aws_iam_role.github_actions.id
  policy = data.aws_iam_policy_document.cloudfront_invalidation.json
}

data "aws_iam_policy_document" "secrets_read" {
  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [aws_secretsmanager_secret.api_base_url.arn]
  }
}

resource "aws_iam_role_policy" "secrets_read" {
  name   = "secrets-read"
  role   = aws_iam_role.github_actions.id
  policy = data.aws_iam_policy_document.secrets_read.json
}

# Terraform state backend access (S3 + DynamoDB lock table) — baked in from
# the start rather than left as a manual gap discovered the hard way after
# CI's first AccessDenied on the state bucket.
data "aws_iam_policy_document" "state_backend" {
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [var.tf_state_bucket_arn]
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["${var.tf_state_bucket_arn}/*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:DeleteItem"]
    resources = [var.tf_lock_table_arn]
  }
}

resource "aws_iam_role_policy" "state_backend" {
  name   = "state-backend"
  role   = aws_iam_role.github_actions.id
  policy = data.aws_iam_policy_document.state_backend.json
}
