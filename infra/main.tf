##############################################################################
# Benson Myrtil Resume — AWS Amplify
#
# Static HTML/CSS/JS resume site deployed via AWS Amplify.
# Connects to GitHub for automatic deployments on push to main.
#
# ESTIMATED COST: ~$0/mo (free tier eligible)
#   - Amplify Hosting: Free tier covers 1000 build minutes/mo, 15 GB served/mo
#   - Beyond free tier: ~$0.01/build-minute, $0.15/GB served
##############################################################################

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = "fsns-internal-prod"

  default_tags {
    tags = {
      Project     = "benson-myrtil-resume"
      ManagedBy   = "terraform"
      Environment = var.environment
      Category    = "internal-apps"
      Owner       = "FSN"
      CostCenter  = "FSN"
    }
  }
}

# Root account provider — Route 53 hosted zones live here
provider "aws" {
  alias   = "root"
  region  = var.aws_region
  profile = "fsns-root"
}

# ── Amplify App ─────────────────────────────────────────────────────────────

resource "aws_amplify_app" "resume" {
  name         = "${var.environment}-benson-myrtil-resume"
  repository   = "https://github.com/${var.github_repository}"
  access_token = var.github_access_token

  platform = "WEB" # Static site — no SSR

  # Build spec for a plain HTML/CSS/JS site — no build step needed
  build_spec = <<-YAML
    version: 1
    frontend:
      phases:
        build:
          commands: []
      artifacts:
        baseDirectory: /
        files:
          - '**/*'
      cache:
        paths: []
  YAML

  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }
}

# ── Branch Deployment ───────────────────────────────────────────────────────

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.resume.id
  branch_name = "main"

  framework = "Web"
  stage     = "PRODUCTION"

  environment_variables = {
    AMPLIFY_MONOREPO_APP_ROOT = "/"
  }
}

# ── Custom Domain ───────────────────────────────────────────────────────────

data "aws_route53_zone" "domain" {
  provider = aws.root
  name     = var.domain_name
}

resource "aws_amplify_domain_association" "resume" {
  app_id                = aws_amplify_app.resume.id
  domain_name           = var.domain_name
  wait_for_verification = false # Verification continues in background

  sub_domain {
    branch_name = aws_amplify_branch.main.branch_name
    prefix      = ""  # apex domain — bensonmyrtil.com
  }

  sub_domain {
    branch_name = aws_amplify_branch.main.branch_name
    prefix      = "www"  # www.bensonmyrtil.com
  }
}
