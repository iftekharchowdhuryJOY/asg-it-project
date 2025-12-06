# ============================================================================
# Target Group
# ============================================================================
# Purpose: Defines a group of EC2 instances that receive traffic from the ALB
# 
# What is a Target Group?
# - A logical grouping of targets (EC2 instances, containers, IPs, Lambda)
# - The ALB uses this to know WHERE to send traffic
# - Performs health checks to ensure targets are healthy
# - ASG automatically registers/deregisters instances with this group
# 
# Traffic Flow:
# Internet → ALB → Listener → Target Group → EC2 Instances (ASG)
# ============================================================================

resource "aws_lb_target_group" "web_tg" {
  name        = "joy-web-tg"
  port        = 80 # Port on which targets receive traffic
  protocol    = "HTTP" # Protocol for routing requests
  target_type = "instance" # Targets are EC2 instances (not IPs or Lambda)
  vpc_id      = data.aws_vpc.default.id # Must be in the same VPC as targets

  # Health Check Configuration
  # ALB periodically sends requests to verify instance health
  health_check {
    path                = "/" # URL path to check (Nginx default page)
    port                = "80" # Port to perform health check on
    protocol            = "HTTP" # Health check protocol
    healthy_threshold   = 2 # Number of consecutive successes to mark healthy
    unhealthy_threshold = 2 # Number of consecutive failures to mark unhealthy
    timeout             = 5 # Seconds to wait for response
    interval            = 30 # Seconds between health checks
    matcher             = "200" # Expected HTTP response code
  }

  # Deregistration Delay
  # Time to wait before deregistering a target (allows in-flight requests to complete)
  deregistration_delay = 30

  tags = {
    Name        = "joy-web-tg"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
