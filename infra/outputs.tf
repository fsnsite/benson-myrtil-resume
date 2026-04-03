output "amplify_app_id" {
  description = "Amplify app ID"
  value       = aws_amplify_app.resume.id
}

output "amplify_default_domain" {
  description = "Default Amplify domain URL"
  value       = "https://main.${aws_amplify_app.resume.default_domain}"
}

output "custom_domain" {
  description = "Custom domain URL"
  value       = "https://${var.domain_name}"
}
