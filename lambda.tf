resource "aws_iam_role" "lambda" {
  name               = "${var.prefix}-lambda"
  assume_role_policy = data.aws_iam_policy_document.trust_policy.json
}

resource "aws_iam_policy" "lambda_ses" {
  name        = "${var.prefix}-lambda-ses"
  description = "Allow ${var.prefix} lambda to send emails via SES."
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

resource "aws_lambda_function" "this" {
  function_name = "${var.prefix}-contact-me-form"
  description   = "This lambda sends an email via SES to owner with details from contact form."
  filename      = "${path.module}/src/init.zip"
  role          = aws_iam_role.lambda.arn
  handler       = "lambda.handler"
  runtime       = var.lambda_runtime

  environment {
    variables = {
      REGION        = var.region
      EMAIL_ADDRESS = var.email_address
    }
  }
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.this.execution_arn}/*/*"
}
