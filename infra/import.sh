#!/usr/bin/env bash
# Import existing Route 53 resources into Terraform state.
# Run once after `terraform init`, then delete this script.
#
# Usage: cd infra && TF_VAR_github_access_token="ghp_..." bash import.sh

set -euo pipefail

ZONE_ID="Z1C8ESRN2ZZCUX"

echo "=== Step 1: Import Route 53 hosted zone ==="
terraform import aws_route53_zone.main "$ZONE_ID"

echo ""
echo "=== Step 2: Import email records (Google Workspace + SES) ==="
terraform import aws_route53_record.mx "${ZONE_ID}_bensonmyrtil.com_MX"
terraform import aws_route53_record.google_site_verification "${ZONE_ID}_bensonmyrtil.com_TXT"
terraform import aws_route53_record.google_dkim "${ZONE_ID}_mail._domainkey.bensonmyrtil.com_TXT"
terraform import aws_route53_record.ses_verification "${ZONE_ID}__amazonses.bensonmyrtil.com_TXT"
terraform import aws_route53_record.ses_dkim_1 "${ZONE_ID}_iypdjwnnhtsyqp567fj5qgudzqjjlj5v._domainkey.bensonmyrtil.com_CNAME"
terraform import aws_route53_record.ses_dkim_2 "${ZONE_ID}_mbn7vipn4iqhkjx2mipaq4lv2zuvxwx5._domainkey.bensonmyrtil.com_CNAME"
terraform import aws_route53_record.ses_dkim_3 "${ZONE_ID}_r2tumdia5llypj3im36onjwxxpzlwaps._domainkey.bensonmyrtil.com_CNAME"

echo ""
echo "=== Step 3: Import ACM validation records ==="
terraform import aws_route53_record.acm_validation_1 "${ZONE_ID}__0b1ede7fd9dbd9a340b39482814b636d.bensonmyrtil.com_CNAME"
terraform import aws_route53_record.acm_validation_2 "${ZONE_ID}__0dcb75afada45558cfdde00afb30926d.bensonmyrtil.com_CNAME"

echo ""
echo "=== Step 4: Import Amplify verification TXT (if exists) ==="
terraform import aws_route53_record.amplify_verification "${ZONE_ID}__amplify.bensonmyrtil.com_TXT" || echo "  (not found — will be created on apply)"

echo ""
echo "Done! Next steps:"
echo "  1. terraform apply  (creates Amplify app + domain association)"
echo "  2. Get CloudFront domain from Amplify domain association"
echo "  3. terraform apply -var='amplify_cloudfront_domain=<domain>'  (creates A/www records)"
