variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "account_id" {
  description = "AWS Account ID for fsns-internal-apps-prod"
  type        = string
  default     = "019493640816"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "prod"
}

variable "github_repository" {
  description = "GitHub repository URL (org/repo format)"
  type        = string
  default     = "fsnsite/benson-myrtil-resume"
}

variable "root_account_id" {
  description = "AWS Root/Management account ID (hosts Route 53 zones)"
  type        = string
  default     = "702175707031"
}

variable "domain_name" {
  description = "Custom domain for the resume site"
  type        = string
  default     = "bensonmyrtil.com"
}

variable "github_access_token" {
  description = "GitHub PAT with 'repo' scope for Amplify to connect to the repository"
  type        = string
  sensitive   = true
}
