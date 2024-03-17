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
  source = "git::https://github.com/kikidawson/tf-aws-module-lambda.git?ref=main"

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
  source_arn    = "${module.apigateway.execution_arn}/*/*"
}

module "apigateway" {
  source = "git::https://github.com/kikidawson/tf-aws-module-apigateway.git?ref=main"

  name        = "${var.prefix}-contact-me-form"
  description = "This is the REST API for the contact me form."
  stage_name  = var.stage_name

  openapi_yaml_file      = "${path.module}/src/openapi.yaml"
  openapi_yaml_variables = {
    "lambda_uri" = "${module.lambda.invoke_arn}"
  }
}
