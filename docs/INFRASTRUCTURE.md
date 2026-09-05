# Infrastructure — sales-funnel Frontend

Vue 3 + Vite static site, deployed to S3 behind CloudFront (OAC, no public bucket), with a custom domain backed by an existing Route53 hosted zone (`vibecheckkits.com`) and an auto-issued/validated ACM certificate.

Two environments are provisioned: **staging** (`staging-portal.vibecheckkits.com`, triggered off the `staging` branch) and **production** (`eservice.vibecheckkits.com`, triggered off `main`, gated by required-reviewer approval on the `production` GitHub Environment — see "Production-specific notes" below).

## Architecture

```
GitHub Actions (push to `staging` / `main`)
  → npm run build (VITE_API_BASE_URL injected)
  → aws s3 sync dist/ → S3 bucket (<environment>-sales-funnel-fe)
  → CloudFront invalidation
                                   ┌────────────────────────┐
Browser → <domain> → CloudFront (OAC) → S3 bucket (private)
                                   └────────────────────────┘
                    ACM cert (us-east-1, DNS-validated via Route53)
                    Route53 A-alias record → CloudFront

  staging domain:    staging-portal.vibecheckkits.com
  production domain: eservice.vibecheckkits.com
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
├── staging.tfvars
└── production.tfvars

.github/workflows/
├── terraform-staging.yml      # single workflow: PR → forced plan + PR comment; push to `staging` → forced apply;
│                               # manual dispatch → choose plan/apply/destroy from the Actions UI
├── deploy-staging.yml         # push to `staging` → build + sync to S3 + invalidate
├── terraform-production.yml   # same shape as terraform-staging.yml, but targets `main` and environment: production
└── deploy-production.yml      # same shape as deploy-staging.yml, but targets `main` and environment: production
```

Both `terraform-*.yml` workflows resolve their action per trigger, and a PR can never resolve to anything but `plan`:

| Trigger | Resolved action | Notes |
|---|---|---|
| `pull_request` → `staging`/`main` | `plan` (forced) | Posts the plan as a PR comment. Never apply/destroy, regardless of any input. |
| `push` → `staging`/`main` | `apply` (forced) | Same as merging a reviewed PR — auto-applies (production additionally pauses for required-reviewer approval, see below). |
| `workflow_dispatch` | `plan` / `apply` / `destroy` (your choice) | For out-of-band plans, applies, or teardown from the Actions UI. |

## One-time account setup (manual — see Step 8/9 output for exact values)

Do these **in order**, from your local machine with your own (admin) AWS credentials. Terraform cannot do step 1 or step 4 itself: `terraform init` needs the state bucket to already exist before it can even read this config, and CI can't authenticate until the IAM role from step 4 has been created once.

1. Create the Terraform state bucket + DynamoDB lock table:

   ```bash
   aws s3api create-bucket \
     --bucket sales-funnel-tf-state-fe \
     --region ap-southeast-1 \
     --create-bucket-configuration LocationConstraint=ap-southeast-1

   aws s3api put-bucket-versioning \
     --bucket sales-funnel-tf-state-fe \
     --versioning-configuration Status=Enabled

   aws s3api put-bucket-encryption \
     --bucket sales-funnel-tf-state-fe \
     --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'

   aws s3api put-public-access-block \
     --bucket sales-funnel-tf-state-fe \
     --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

   aws dynamodb create-table \
     --table-name sales-funnel-tf-lock-fe \
     --attribute-definitions AttributeName=LockID,AttributeType=S \
     --key-schema AttributeName=LockID,KeyType=HASH \
     --billing-mode PAY_PER_REQUEST \
     --region ap-southeast-1
   ```

2. Create the GitHub OIDC identity provider in the AWS account (one-time, if not already present from another project in this account):

   ```bash
   aws iam create-open-id-connect-provider \
     --url https://token.actions.githubusercontent.com \
     --client-id-list sts.amazonaws.com \
     --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1
   ```

3. Confirm the Route53 hosted zone for `vibecheckkits.com` already exists in this AWS account — `route53.tf` only reads it via a data source, it will not create it.
4. Fill in `terraform/staging.tfvars`'s two placeholders (`github_oidc_sub`, `tf_lock_table_arn`'s `<ACCOUNT_ID>`), then run the **first** `terraform init`/`plan`/`apply` locally (not from CI — the deploy role doesn't exist yet for CI to assume):

   ```bash
   cd terraform
   terraform init \
     -backend-config="bucket=sales-funnel-tf-state-fe" \
     -backend-config="key=sales-funnel/staging/terraform.tfstate" \
     -backend-config="region=ap-southeast-1" \
     -backend-config="dynamodb_table=sales-funnel-tf-lock-fe" \
     -backend-config="encrypt=true"

   terraform plan -var-file=staging.tfvars
   terraform apply -var-file=staging.tfvars
   ```

5. Create the `staging` GitHub environment and populate its variables from the `terraform apply` outputs (see the values table in the chat output).
6. Push to the `staging` branch to trigger the first CI-driven deploy (and, via `terraform-staging.yml`'s push trigger, the first CI-driven `terraform apply` for any subsequent infra changes).

## Notes specific to this stack

- **ACM/DNS is fully Terraform-managed.** `route53.tf` requests the cert in `us-east-1` (required by CloudFront regardless of the stack's own region), writes the DNS validation records into the existing zone, waits for validation, then creates the `A` alias record pointing `staging.vibecheckkits.com` at the distribution. The very first apply may take several minutes while ACM validates.
- **SPA routing** is handled via CloudFront custom error responses (403 and 404 → `/index.html`, 200) rather than S3 website hosting — required because the bucket has all public access blocked and is only reachable via CloudFront OAC.
- `bucket_name` (`staging-sales-funnel-fe`) must be globally unique across all of S3. If Terraform fails with `BucketAlreadyOwnedByYou` or `BucketAlreadyExists`, pick a different name in `staging.tfvars`.

## Production-specific notes

Production reuses the same shared account-level infrastructure as staging (Terraform state bucket, DynamoDB lock table, GitHub OIDC provider, Route53 hosted zone) — only a separate state key (`sales-funnel/production/terraform.tfstate`), S3 bucket, CloudFront distribution, and IAM role (scoped to `environment:production` in its OIDC trust condition) are new.

- **Approval gate.** The `production` GitHub Environment has required reviewers configured (Settings → Environments → production). Because both `terraform-production.yml` and `deploy-production.yml` declare `environment: production`, every run of either workflow — plan, apply, destroy, or deploy — pauses for manual approval before executing. This is a GitHub Environment protection rule, not something expressed in the workflow YAML itself.
- **Domain.** `custom_domain = "eservice.vibecheckkits.com"` in `production.tfvars` is a subdomain of the same `root_domain` hosted zone staging uses. An earlier attempt used the bare apex (`vibecheckkits.com`) and failed with CloudFront's `CNAMEAlreadyExists` — that alias was already attached to a different, pre-existing CloudFront distribution (CloudFront enforces global uniqueness on Alternate Domain Names across all of AWS, independent of Route53). Before applying, it's still worth a quick check that nothing already claims this specific subdomain, in both Route53 and CloudFront:
  ```bash
  ZONE_ID=$(aws route53 list-hosted-zones-by-name --dns-name vibecheckkits.com. --query "HostedZones[0].Id" --output text)
  aws route53 list-resource-record-sets --hosted-zone-id "$ZONE_ID" \
    --query "ResourceRecordSets[?Name=='eservice.vibecheckkits.com.']"
  aws cloudfront list-distributions \
    --query "DistributionList.Items[?contains(Aliases.Items, 'eservice.vibecheckkits.com')]"
  ```
- **Bootstrap order** mirrors staging's One-time account setup above, with these production-specific substitutions: use `production.tfvars` and `-backend-config="key=sales-funnel/production/terraform.tfstate"` for the first local `terraform init`/`plan`/`apply`; create the `production` GitHub Environment (with required reviewers) instead of `staging`; populate its variables from this stack's own `terraform output`; then push to `main` to trigger the first CI-driven deploy/apply.
- **`api_base_url`** in `production.tfvars` is a placeholder (`https://api.vibecheckkits.com`) until the production backend is live — update it (and the `API_BASE_URL` GitHub Environment variable) before go-live.
