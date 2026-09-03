# Troubleshooting — sales-funnel Frontend Infrastructure

## `terraform apply` fails with `BucketAlreadyOwnedByYou` or `BucketAlreadyExists`

S3 bucket names are globally unique across all AWS accounts. Someone (possibly you, in an earlier failed run) already owns `staging-sales-funnel-fe`. Never pre-create the bucket manually — it's fully Terraform-managed (`s3.tf`). Pick a different `bucket_name` in `staging.tfvars` instead.

## GitHub Actions fails to assume the IAM role (`AccessDenied` / `InvalidIdentityToken`)

Almost always a mismatch between `github_oidc_sub` in `staging.tfvars` and the actual OIDC `sub` claim GitHub sends. Add a temporary debug step to the failing workflow:

```yaml
- name: Debug OIDC token
  run: |
    echo "${{ toJSON(github) }}"
```

(Remove it again once you've confirmed the value — it's a diagnostic aid, not something to leave shipped.) Confirm `github_oidc_sub` matches `repo:<org>@<org-id>/<repo>@<repo-id>` exactly, and that the workflow's `environment: staging` matches `github_environment` in `staging.tfvars` — the trust policy does an exact match on `<sub>:environment:<github_environment>`, so a name mismatch (e.g. `staging` vs `Staging`) fails silently with a generic `AccessDenied`.

## ACM certificate stuck in `PENDING_VALIDATION`

- Confirm `root_domain` (`vibecheckkits.com`) really is hosted in Route53 **in this AWS account** — `aws_route53_zone` is a data source, so if the zone doesn't exist here, `terraform plan` fails immediately with a lookup error rather than hanging.
- If the zone exists but validation is slow, DNS propagation can take a few minutes; `aws_acm_certificate_validation` will wait up to its default timeout before failing the apply — re-running `terraform apply` is safe once records have propagated.
- Check for a duplicate/conflicting CNAME already present at the validation record name in the zone (e.g. from a previous manual certificate request) — Route53 will refuse to create a second record with the same name/type.

## CloudFront serves a 403 instead of the app on a client-side route (e.g. `/dashboard`)

Confirm both `custom_error_response` blocks (403 **and** 404) are present in `cloudfront.tf`. S3 returns 403, not 404, for a missing key once public access is blocked — a 404-only rule silently fails to redirect client-side routes to `index.html`.

## Site not updating after a deploy

`deploy-staging.yml` runs `aws s3 sync --delete` then a CloudFront invalidation (`/*`). If the S3 sync succeeded but the site still shows stale content, check the invalidation actually completed — `aws cloudfront get-invalidation --distribution-id <id> --id <invalidation-id>` — invalidations can take several minutes to fully propagate to all edge locations.

## First apply run from CI fails / role doesn't exist yet

Expected — the deploy role (`staging-sales-funnel-fe-github-actions`) is itself created *by* the first `terraform apply`, so there's nothing for CI to authenticate with until that first apply has run **locally** with your own AWS credentials. See `docs/INFRASTRUCTURE.md`.
