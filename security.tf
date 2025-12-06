# ============================================================================
# Security Group Configuration
# ============================================================================
# Purpose: Defines firewall rules for EC2 instances and Application Load Balancer
# 
# Security Considerations:
# - Currently allows HTTP traffic from anywhere (0.0.0.0/0)
# - For production: Consider restricting ingress to ALB security group only
# - No SSH access configured (use Systems Manager Session Manager instead)
# ============================================================================

resource "aws_security_group" "web_sg" {
  name        = "asg-web-sg"
  description = "Security group for ASG instances and ALB"

  # Inbound Rules
  # Allow HTTP traffic from the internet (required for public-facing web servers)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # WARNING: Open to the world. For production, use ALB SG only
  }

  # Outbound Rules
  # Allow all outbound traffic (needed for yum updates, package downloads, etc.)
  egress {
    from_port   = 0           # All ports
    to_port     = 0           # All ports
    protocol    = "-1"        # All protocols
    cidr_blocks = ["0.0.0.0/0"] # To anywhere
  }

  # Best Practice: Add tags for resource management
  tags = {
    Name        = "asg-web-sg"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}