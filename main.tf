module "s3" {
  source = "git::https://github.com/kikidawson/tf-aws-module-s3.git?ref=main"

  name = "${var.prefix}-contact-me-form-app"

  sse_bucket_key_enabled = true
  sse_algorithm          = "AES256"

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  policy_document_json = data.aws_iam_policy_document.allow_get_put_object.json

  website_file_name = "index.html"
}

module "lambda" {
  source = "../tf-aws-module-lambda"

  name                   = "${var.prefix}-contact-me-form"
  description            = "This lambda sends an email via SES to owner with details from contact form."
  additional_policy_json = data.aws_iam_policy_document.lambda_ses.json

  environment_variables = {
    REGION        = var.region
    EMAIL_ADDRESS = var.email_address
  }
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.this.execution_arn}/*/*"
}
