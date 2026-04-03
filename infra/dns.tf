##############################################################################
# DNS — Route 53
#
# The bensonmyrtil.com hosted zone lives in the root account (702175707031).
# All resources here use the aws.root provider.
#
# Records imported from existing manual configuration.
# NS and SOA records are AWS-managed and not tracked here.
##############################################################################

# ── Hosted Zone ─────────────────────────────────────────────────────────────

resource "aws_route53_zone" "main" {
  provider = aws.root
  name     = var.domain_name
}

# ── Amplify Cross-Account Domain Verification ───────────────────────────────
# Required because Amplify is in a different account than Route 53.
# The TXT value is the Amplify app ID.

resource "aws_route53_record" "amplify_verification" {
  provider        = aws.root
  zone_id         = aws_route53_zone.main.zone_id
  name            = "_amplify.${var.domain_name}"
  type            = "TXT"
  ttl             = 300
  allow_overwrite = true

  records = [aws_amplify_app.resume.id]
}

# ── Email (Google Workspace) ────────────────────────────────────────────────

resource "aws_route53_record" "mx" {
  provider = aws.root
  zone_id  = aws_route53_zone.main.zone_id
  name     = var.domain_name
  type     = "MX"
  ttl      = 300

  records = [
    "1 ASPMX.L.GOOGLE.COM.",
    "5 ALT1.ASPMX.L.GOOGLE.COM.",
    "5 ALT2.ASPMX.L.GOOGLE.COM.",
    "10 ASPMX2.GOOGLEMAIL.COM.",
    "10 ASPMX3.GOOGLEMAIL.COM.",
  ]
}

resource "aws_route53_record" "google_site_verification" {
  provider = aws.root
  zone_id  = aws_route53_zone.main.zone_id
  name     = var.domain_name
  type     = "TXT"
  ttl      = 300

  records = [
    "google-site-verification=nkMNsOfyGlDXgYa8vwtzrxeVqU0NcGtDEhXs0XavXcg",
  ]
}

resource "aws_route53_record" "google_dkim" {
  provider = aws.root
  zone_id  = aws_route53_zone.main.zone_id
  name     = "mail._domainkey.${var.domain_name}"
  type     = "TXT"
  ttl      = 300

  records = [
    "v=DKIM1; k=rsa; t=s; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDTh/LlfJmeyXegSN51nP1jvz57/OaGT7Bh3b+JDZ8BW+5N7OxTS8UuDGFmzUt1F/5aIImJdAoQO/i8n0Uf22WkAzdJOoIDJ5C/QviOTn/tUKDc2psEoy5n9wpVPi2tbwjoNX/WnIv1a1KuurEZBu6h09eVE9Ew3/mNgmDsukPvGQIDAQAB",
  ]
}

# ── SES (Amazon Email Service) ──────────────────────────────────────────────

resource "aws_route53_record" "ses_verification" {
  provider = aws.root
  zone_id  = aws_route53_zone.main.zone_id
  name     = "_amazonses.${var.domain_name}"
  type     = "TXT"
  ttl      = 1800

  records = [
    "yBPQWhAeq/P3blcx/EfgQgKTVpfXwbyHm9OXckKXUDA=",
  ]
}

resource "aws_route53_record" "ses_dkim_1" {
  provider = aws.root
  zone_id  = aws_route53_zone.main.zone_id
  name     = "iypdjwnnhtsyqp567fj5qgudzqjjlj5v._domainkey.${var.domain_name}"
  type     = "CNAME"
  ttl      = 1800

  records = ["iypdjwnnhtsyqp567fj5qgudzqjjlj5v.dkim.amazonses.com"]
}

resource "aws_route53_record" "ses_dkim_2" {
  provider = aws.root
  zone_id  = aws_route53_zone.main.zone_id
  name     = "mbn7vipn4iqhkjx2mipaq4lv2zuvxwx5._domainkey.${var.domain_name}"
  type     = "CNAME"
  ttl      = 1800

  records = ["mbn7vipn4iqhkjx2mipaq4lv2zuvxwx5.dkim.amazonses.com"]
}

resource "aws_route53_record" "ses_dkim_3" {
  provider = aws.root
  zone_id  = aws_route53_zone.main.zone_id
  name     = "r2tumdia5llypj3im36onjwxxpzlwaps._domainkey.${var.domain_name}"
  type     = "CNAME"
  ttl      = 1800

  records = ["r2tumdia5llypj3im36onjwxxpzlwaps.dkim.amazonses.com"]
}

# ── Amplify Hosting Records ─────────────────────────────────────────────────
# Points bensonmyrtil.com and www.bensonmyrtil.com to the Amplify CloudFront.
# Replaces the old CloudFront distribution records.

resource "aws_route53_record" "apex" {
  provider = aws.root
  zone_id  = aws_route53_zone.main.zone_id
  name     = var.domain_name
  type     = "A"

  alias {
    name                   = "dst0di3f1tu3x.cloudfront.net"
    zone_id                = "Z2FDTNDATAQYW2" # Global CloudFront hosted zone ID
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www" {
  provider = aws.root
  zone_id  = aws_route53_zone.main.zone_id
  name     = "www.${var.domain_name}"
  type     = "CNAME"
  ttl      = 300

  records = ["dst0di3f1tu3x.cloudfront.net"]
}

# ── ACM Certificate Validation ──────────────────────────────────────────────
# Used by Amplify for SSL certificate verification.

resource "aws_route53_record" "acm_validation_1" {
  provider = aws.root
  zone_id  = aws_route53_zone.main.zone_id
  name     = "_0b1ede7fd9dbd9a340b39482814b636d.${var.domain_name}"
  type     = "CNAME"
  ttl      = 500

  records = ["_243e0745328cfcccb90a3b16e77f4d4d.zbkrxsrfvj.acm-validations.aws."]
}

resource "aws_route53_record" "acm_validation_2" {
  provider = aws.root
  zone_id  = aws_route53_zone.main.zone_id
  name     = "_0dcb75afada45558cfdde00afb30926d.${var.domain_name}"
  type     = "CNAME"
  ttl      = 300

  records = ["_54d8873b3250b1fd2e4ec1807dca6686.acm-validations.aws."]
}
