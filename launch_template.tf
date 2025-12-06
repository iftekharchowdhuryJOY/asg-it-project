# ============================================================================
# EC2 Launch Template
# ============================================================================
# Purpose: Defines the configuration blueprint for EC2 instances in the ASG
# 
# What is a Launch Template?
# - A reusable configuration that specifies instance settings
# - Supports versioning for blue/green deployments
# - Newer and more feature-rich than Launch Configurations
# 
# Key Components:
# - AMI: Operating system image
# - Instance Type: Compute capacity (CPU, RAM)
# - Network Settings: VPC, subnet, security groups, public IP
# - User Data: Bootstrap script that runs on first launch
# ============================================================================

resource "aws_launch_template" "web_lt" {
  name_prefix   = "joy-web-lt-" # Terraform will append unique suffix
  image_id      = data.aws_ami.latest_nginx_ami.id # Dynamically fetched Amazon Linux 2 AMI
  instance_type = var.instance_type # Configurable via variables (default: t2.micro)

  # Network Configuration
  # Instances need public IPs to be accessible via the internet-facing ALB
  network_interfaces {
    associate_public_ip_address = true # Required for internet access in default VPC
    security_groups             = [aws_security_group.web_sg.id] # Firewall rules
  }

  # User Data Script
  # This bash script runs automatically when the instance first boots
  # It installs and configures Nginx web server
  user_data = base64encode(<<-EOF
  #!/bin/bash
  # Update all system packages to latest versions (security patches)
  yum update -y
  
  # Install Nginx web server using Amazon Linux Extras repository
  amazon-linux-extras install nginx1 -y
  
  # Enable Nginx to start automatically on system boot
  systemctl enable nginx
  
  # Fetch instance ID from EC2 metadata service (identifies which instance is serving the request)
  INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
  
  # Create a custom HTML page showing the instance ID
  # This helps verify load balancing is working correctly
  echo "<h1>Hello from $INSTANCE_ID</h1>" > /usr/share/nginx/html/index.html
  
  # Start the Nginx web server
  systemctl start nginx
EOF
  )

  # Tag Specification
  # Tags applied to instances launched from this template
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Joy-ASG-Instance"
      ManagedBy = "terraform"
      Application = "web-server"
    }
  }

  # Best Practice: Enable detailed monitoring for production
  # monitoring {
  #   enabled = true
  # }
}
