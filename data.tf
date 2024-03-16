data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "trust_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "allow_get_put_object" {
  #checkov:skip=CKV_AWS_283: wildcard in principal

  statement {
    sid = "AllowReadAndWrite"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = ["${module.s3.arn}/*"]
  }
}

data "aws_iam_policy_document" "lambda_ses" {
  #checkov:skip=CKV_AWS_356: wildcard in statement
  #checkov:skip=CKV_AWS_111: write access without constraints

  statement {
    effect    = "Allow"
    actions   = ["ses:SendEmail"]
    resources = ["*"]
  }
}
