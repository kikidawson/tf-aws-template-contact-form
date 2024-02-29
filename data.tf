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

    resources = ["${aws_s3_bucket.this.arn}/*"]
  }
}

data "aws_iam_policy_document" "lambda_ses" {
  statement {
    effect    = "Allow"
    actions   = ["ses:SendEmail"]
    resources = ["*"]
  }
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "./src/cmf-lambda.js"
  output_path = "./src/cmf-lambda.zip"
}
