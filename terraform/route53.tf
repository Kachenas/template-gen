# Custom domain support: looks up an existing Route53 hosted zone for
# var.root_domain and fully automates ACM issuance (DNS validation) plus the
# CloudFront alias record. Only created when var.custom_domain is set.

data "aws_route53_zone" "root" {
  count = var.custom_domain != "" ? 1 : 0
  name  = var.root_domain
}

resource "aws_acm_certificate" "site" {
  count             = var.custom_domain != "" ? 1 : 0
  provider          = aws.us_east_1
  domain_name       = var.custom_domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = var.custom_domain != "" ? {
    for dvo in aws_acm_certificate.site[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  zone_id = data.aws_route53_zone.root[0].zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

resource "aws_acm_certificate_validation" "site" {
  count                   = var.custom_domain != "" ? 1 : 0
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.site[0].arn
  validation_record_fqdns = [for r in aws_route53_record.cert_validation : r.fqdn]
}

resource "aws_route53_record" "site_alias" {
  count   = var.custom_domain != "" ? 1 : 0
  zone_id = data.aws_route53_zone.root[0].zone_id
  name    = var.custom_domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
    evaluate_target_health = false
  }
}

locals {
  acm_certificate_arn = var.custom_domain != "" ? aws_acm_certificate_validation.site[0].certificate_arn : ""
}
