module "s3" {
  source = "git@github.com:kikidawson/tf-aws-module-s3.git"

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
