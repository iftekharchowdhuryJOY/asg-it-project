# ============================================================================
# AMI Data Source
# ============================================================================
# Purpose: Dynamically fetches the latest Amazon Linux 2 AMI
# 
# Why use a data source instead of hardcoding AMI ID?
# - AMI IDs change with each release and vary by region
# - This ensures we always use the latest patched version
# - Reduces maintenance burden and improves security posture
# ============================================================================

data "aws_ami" "latest_nginx_ami" {
  most_recent = true # Always select the newest matching AMI

  # Filter by AMI name pattern
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"] # Amazon Linux 2, HVM virtualization, x86_64, GP2 storage
  }

  owners = ["amazon"] # Official Amazon-published AMIs only (prevents using untrusted images)
}
