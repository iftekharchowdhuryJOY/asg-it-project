# ============================================================================
# Application Load Balancer (ALB)
# ============================================================================
# Purpose: Distributes incoming HTTP traffic across multiple EC2 instances
# 
# Why use an ALB?
# - High Availability: Distributes traffic across multiple AZs
# - Health Checks: Automatically routes traffic away from unhealthy instances
# - Scalability: Handles thousands of requests per second
# - SSL/TLS Termination: Can handle HTTPS encryption (not configured here)
# - Path-based Routing: Can route to different targets based on URL path
# 
# Architecture:
# - Internet-facing: Accessible from the public internet
# - Deployed across multiple AZs for fault tolerance
# - Forwards traffic to ASG instances via target group
# ============================================================================

resource "aws_lb" "web_alb" {
  name               = "joy-web-alb"
  internal           = false # Internet-facing (set to true for internal ALBs)
  load_balancer_type = "application" # Layer 7 (HTTP/HTTPS) load balancer

  # Security: ALB uses the same security group as instances
  # Production: Create separate security groups for ALB and instances
  security_groups = [aws_security_group.web_sg.id]

  # Deploy ALB across multiple subnets (AZs) for high availability
  # ALB requires at least 2 subnets in different AZs
  subnets = data.aws_subnets.default.ids

  # Best Practice: Enable access logs for troubleshooting
  # access_logs {
  #   bucket  = aws_s3_bucket.alb_logs.id
  #   enabled = true
  # }

  # Best Practice: Enable deletion protection for production
  # enable_deletion_protection = true

  tags = {
    Name        = "joy-web-alb"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

