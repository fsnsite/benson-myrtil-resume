# Benson Myrtil Resume — Claude Code Context

## What This App Is

Personal resume/portfolio site for Benson Myrtil. A static HTML/CSS/JS site — no backend, no database, no build step.

## Tech Stack

- **Frontend:** HTML, CSS, JavaScript (Bootstrap, jQuery, Font Awesome)
- **Backend:** None (static site)
- **Database:** None
- **Hosting:** AWS Amplify

## FSNS Organization Context

This app is part of the FSNS multi-account AWS organization. Infrastructure standards are defined in the [fsns-infrastructure](https://github.com/fsnsite/fsns-infrastructure) repo.

### Account Placement

- **Account:** `fsns-internal-apps-prod` (`019493640816`)
- **Category:** `internal-apps`
- **AWS Profile:** `fsns-internal-prod`
- **Region:** us-east-1

### Required Tags (all AWS resources)

```hcl
Environment = "prod"
Category    = "internal-apps"
Owner       = "FSN"
CostCenter  = "FSN"
ManagedBy   = "terraform"
Project     = "benson-myrtil-resume"
```

## Infrastructure

App-specific infrastructure lives in `infra/` and is managed with Terraform.

- **State backend:** `s3://terraform-state-fsn-702175707031`
- **State key:** `benson-myrtil-resume-prod/terraform.tfstate`
- **Lock table:** `terraform-locks` (DynamoDB)

### Deploying Infrastructure

```bash
cd infra
terraform init
terraform plan
terraform apply
```

Requires AWS SSO session: `aws sso login --sso-session fsns`

## Development

Open `index.html` in a browser — no build tools or dev server needed.

## Domain

- **Custom domain:** `bensonmyrtil.com` (and `www.bensonmyrtil.com`)
- **Route 53 zone:** Hosted in root account (`702175707031`)
- **SSL:** Managed automatically by Amplify

## Deployment

Amplify auto-deploys on push to `main` branch via GitHub integration. No CI/CD pipeline to configure.

## Cost

~$0/mo — well within Amplify free tier (1,000 build min/mo, 15 GB served/mo).
