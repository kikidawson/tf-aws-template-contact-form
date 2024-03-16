data "github_repository" "tf_aws_template_contact_form" {
  full_name = "kikidawson/tf-aws-template-contact-form"
}

resource "github_branch_protection" "main" {
  repository_id = data.github_repository.tf_aws_template_contact_form.node_id

  pattern          = "main"
  enforce_admins   = true
  allows_deletions = false
  require_conversation_resolution = true

  required_pull_request_reviews {
    require_last_push_approval      = false
    required_approving_review_count = 1
  }
}
