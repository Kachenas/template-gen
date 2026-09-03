variable "environment" {
  description = "Deployment environment (staging, production)"
  type        = string

  validation {
    condition     = contains(["staging", "production"], var.environment)
    error_message = "environment must be 'staging' or 'production'."
  }
}

variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "ap-southeast-1"
}

variable "github_org_repo" {
  description = "GitHub org/repo (e.g. 'Kachenas/template-gen')"
  type        = string
}

variable "github_oidc_sub" {
  description = "OIDC sub claim prefix including numeric IDs (e.g. 'repo:Kachenas@123/template-gen@456'). Get this from the debug OIDC step in the workflow."
  type        = string
}

variable "github_environment" {
  description = "GitHub Actions environment name this trust policy is scoped to (staging or production) — used to build an exact-match sub claim instead of a bare wildcard"
  type        = string

  validation {
    condition     = contains(["staging", "production"], var.github_environment)
    error_message = "github_environment must be 'staging' or 'production'."
  }
}

variable "bucket_name" {
  description = "S3 bucket name for the static site"
  type        = string
}

variable "api_base_url" {
  description = "Backend API base URL injected at build time"
  type        = string
}

variable "tf_state_bucket_arn" {
  description = "ARN of the S3 bucket used for Terraform state (for this role's own state-backend access policy)"
  type        = string
}

variable "tf_lock_table_arn" {
  description = "ARN of the DynamoDB table used for Terraform state locking"
  type        = string
}

variable "custom_domain" {
  description = "Custom domain for CloudFront (e.g. 'staging.vibecheckkits.com'). Leave blank to use the default *.cloudfront.net domain."
  type        = string
  default     = ""
}

variable "root_domain" {
  description = "Apex domain whose existing Route53 hosted zone will host the ACM validation and alias records for custom_domain (e.g. 'vibecheckkits.com'). Required if custom_domain is set."
  type        = string
  default     = ""
}

variable "price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_100"
}
