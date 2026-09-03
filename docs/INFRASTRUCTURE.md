# Infrastructure — sales-funnel Frontend

Vue 3 + Vite static site, deployed to S3 behind CloudFront (OAC, no public bucket), with a custom domain (`staging.vibecheckkits.com`) backed by an existing Route53 hosted zone (`vibecheckkits.com`) and an auto-issued/validated ACM certificate.

Only the **staging** environment is provisioned in this pass. Add `production.tfvars` + the `terraform-plan-production.yml`/`terraform-production.yml`/`deploy-production.yml` triad later, following the staging files as a template, when production is ready.

## Architecture

```
GitHub Actions (push to `staging`)
  → npm run build (VITE_API_BASE_URL injected)
  → aws s3 sync dist/ → S3 bucket (staging-sales-funnel-fe)
  → CloudFront invalidation
                                   ┌────────────────────────┐
Browser → staging.vibecheckkits.com → CloudFront (OAC) → S3 bucket (private)
                                   └────────────────────────┘
                    ACM cert (us-east-1, DNS-validated via Route53)
                    Route53 A-alias record → CloudFront
```

## Directory layout

```
terraform/
├── main.tf         # providers (default region + us-east-1 alias for ACM)
├── variables.tf
├── oidc.tf          # data source for the existing GitHub OIDC provider
├── iam.tf           # GitHub Actions deploy role + scoped inline policies
├── s3.tf            # site bucket + api-base-url secret
├── cloudfront.tf    # distribution + OAC
├── route53.tf        # zone lookup, ACM cert + DNS validation, alias record
├── outputs.tf
└── staging.tfvars

.github/workflows/
├── terraform-plan-staging.yml   # PR → plan only, comments on the PR
├── terraform-staging.yml        # push to `staging` or manual dispatch → apply/destroy
└── deploy-staging.yml           # push to `staging` → build + sync to S3 + invalidate
```

## One-time account setup (manual — see Step 8/9 output for exact values)

1. Create the Terraform state bucket + DynamoDB lock table (`references/terraform-frontend.md` bootstrap commands, substituting `sales-funnel`).
2. Create the GitHub OIDC identity provider in the AWS account (one-time, if not already present from another project in this account).
3. Confirm the Route53 hosted zone for `vibecheckkits.com` already exists in this AWS account — `route53.tf` only reads it via a data source, it will not create it.
4. Run the **first** `terraform apply` locally (not from CI — the deploy role doesn't exist yet for CI to assume).
5. Create the `staging` GitHub environment and populate its variables (see the values table in the chat output).
6. Push to the `staging` branch to trigger the first deploy.

## Notes specific to this stack

- **ACM/DNS is fully Terraform-managed.** `route53.tf` requests the cert in `us-east-1` (required by CloudFront regardless of the stack's own region), writes the DNS validation records into the existing zone, waits for validation, then creates the `A` alias record pointing `staging.vibecheckkits.com` at the distribution. The very first apply may take several minutes while ACM validates.
- **SPA routing** is handled via CloudFront custom error responses (403 and 404 → `/index.html`, 200) rather than S3 website hosting — required because the bucket has all public access blocked and is only reachable via CloudFront OAC.
- `bucket_name` (`staging-sales-funnel-fe`) must be globally unique across all of S3. If Terraform fails with `BucketAlreadyOwnedByYou` or `BucketAlreadyExists`, pick a different name in `staging.tfvars`.
