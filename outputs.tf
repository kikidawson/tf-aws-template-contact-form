output "apigateway_stage_invoke_url" {
  description = "The invoke URL to be added into the HTML file."
  value       = module.apigateway.invoke_url
}
