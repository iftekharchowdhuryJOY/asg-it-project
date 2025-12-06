# ============================================================================
# AWS Provider Configuration
# ============================================================================
# Purpose: Configures the AWS provider for Terraform to manage resources
# Region:  ca-central-1 (Canada - Montreal)
# 
# Notes:
# - Credentials are sourced from AWS CLI configuration or environment variables
# - Ensure AWS credentials are configured via 'aws configure' before running
# - This region was chosen to comply with data residency requirements
# ============================================================================

provider "aws" {
  region = "ca-central-1"
}

