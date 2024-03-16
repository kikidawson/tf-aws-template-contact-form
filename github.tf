data "github_repository" "tf_aws_template_contact_form" {
  full_name = "kikidawson/tf-aws-template-contact-form"
}

resource "github_branch_protection" "main" {
  #checkov:skip=CKV_GIT_6: requires signed commits
  #checkov:skip=CKV_GIT_5: needs at least 2 approvals but I'm a party of 1 so no.

  repository_id = data.github_repository.tf_aws_template_contact_form.node_id

  pattern                         = "main"
  enforce_admins                  = true
  allows_deletions                = false
  require_conversation_resolution = true

  required_pull_request_reviews {
    require_last_push_approval      = false
    required_approving_review_count = 0
  }
}
