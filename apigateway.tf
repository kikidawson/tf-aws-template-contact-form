resource "aws_api_gateway_rest_api" "this" {
  name        = "${var.prefix}-contact-me-form"
  description = "This is the REST API for the contact me form."

  body = templatefile("${path.module}/src/openapi.yaml", {
    "lambda_uri" = "${aws_lambda_function.this.invoke_arn}"
  })

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(yamlencode(aws_api_gateway_rest_api.this.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = var.stage_name
}
