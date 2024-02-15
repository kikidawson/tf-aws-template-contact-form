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

resource "aws_iam_role" "lambda" {
  name                = "cmf-lambda"
  assume_role_policy  = data.aws_iam_policy_document.trust_policy.json
}

data "aws_iam_policy_document" "lambda_ses" {
  statement {
    effect    = "Allow"
    actions   = ["ses:SendEmail"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "lambda_ses" {
  name        = "cmf-lambda-ses"
  description = "Allow CMF lambda to send emails via SES."
  policy      = data.aws_iam_policy_document.lambda_ses.json
}

resource "aws_iam_role_policy_attachment" "ses" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda_ses.arn
}

resource "aws_iam_role_policy_attachment" "basic" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "./src/cmf-lambda.js"
  output_path = "./src/cmf-lambda.zip"
}

resource "aws_lambda_function" "this" {
  function_name    = "cmf-contact-me-form"
  description      = "This lambda sends an email via SES to owner with details from contact form."
  filename         = "${path.module}/src/cmf-lambda.zip"
  role             = aws_iam_role.lambda.arn
  handler          = "cmf-lambda.handler"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime          = "nodejs16.x"
}
