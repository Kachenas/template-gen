terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    # Configured at init via -backend-config flags:
    #   -backend-config="bucket=<state-bucket>"
    #   -backend-config="key=frontend/<env>/terraform.tfstate"
    #   -backend-config="region=<region>"
    #   -backend-config="dynamodb_table=<lock-table>"
    #   -backend-config="encrypt=true"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "sales-funnel-frontend"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}

# CloudFront only accepts ACM certificates issued in us-east-1, regardless of
# which region the rest of this stack (S3, the distribution itself) lives in.
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"

  default_tags {
    tags = {
      Project     = "sales-funnel-frontend"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}
