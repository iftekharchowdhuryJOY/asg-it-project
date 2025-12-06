# ============================================================================
# Auto Scaling Group (ASG) Configuration
# ============================================================================
# Purpose: Creates a highly available, self-healing web application infrastructure
# 
# Architecture Overview:
# - Uses default VPC for simplicity (production should use custom VPC)
# - Deploys instances across multiple AZs for high availability
# - Integrates with ALB for load distribution
# - Automatically replaces unhealthy instances
# ============================================================================

# Data Source: Fetch Default VPC
# The default VPC is automatically created by AWS in every region
data "aws_vpc" "default" {
  default = true
}

# Data Source: Fetch Subnets from Default VPC
# Filters ensure we only use subnets in AZs that support t2.micro instances
data "aws_subnets" "default" {
  # Only select default subnets (one per AZ)
  filter {
    name   = "default-for-az"
    values = ["true"]
  }

  # CRITICAL: Restrict to AZs where t2.micro is available
  # ca-central-1d does NOT support t2.micro, causing launch failures
  filter {
    name   = "availability-zone"
    values = ["ca-central-1a", "ca-central-1b"]
  }
}

# Auto Scaling Group Resource
# Manages a fleet of EC2 instances that scale based on demand
resource "aws_autoscaling_group" "web_asg" {
  name                = "joy-web-asg"
  desired_capacity    = 2 # Normal operating capacity
  min_size            = 2 # Minimum for high availability (one per AZ)
  max_size            = 4 # Maximum during scale-out events
  vpc_zone_identifier = data.aws_subnets.default.ids # Deploy across multiple AZs

  # Integration with Application Load Balancer
  # ASG automatically registers new instances with this target group
  target_group_arns = [aws_lb_target_group.web_tg.arn]

  # Launch Template defines the instance configuration
  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest" # Always use the latest version (enables blue/green deployments)
  }
  instance_warmup = 180

  # Resource Tagging
  # Tags are propagated to all EC2 instances launched by this ASG
  tag {
    key                 = "Name"
    value               = "Joy-ASG-Web"
    propagate_at_launch = true # Apply tag to instances, not just the ASG
  }

  # Best Practice: Add lifecycle hooks for graceful shutdown
  # Uncomment for production to allow connection draining
  # lifecycle {
  #   create_before_destroy = true
  # }
}
