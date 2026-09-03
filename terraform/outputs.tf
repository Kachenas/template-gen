output "iam_role_arn" { value = aws_iam_role.github_actions.arn }
output "s3_bucket_name" { value = aws_s3_bucket.site.id }
output "cloudfront_distribution_id" { value = aws_cloudfront_distribution.site.id }
output "cloudfront_domain_name" { value = aws_cloudfront_distribution.site.domain_name }
output "api_base_url_secret_arn" { value = aws_secretsmanager_secret.api_base_url.arn }
output "custom_domain_url" {
  value       = var.custom_domain != "" ? "https://${var.custom_domain}" : null
  description = "The site's custom domain URL, once DNS/ACM validation completes (can take several minutes on first apply)."
}
