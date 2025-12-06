# ============================================================================
# Terraform Outputs
# ============================================================================
# Purpose: Exposes important resource information after deployment
# 
# Why use outputs?
# - Display critical information (like ALB DNS name) after 'terraform apply'
# - Pass values to other Terraform modules or configurations
# - Use in automation scripts via 'terraform output -json'
# - Document important resource identifiers for team members
# 
# View outputs:
# - terraform output                 (shows all outputs)
# - terraform output alb_dns_name    (shows specific output)
# - terraform output -json           (JSON format for scripting)
# ============================================================================

# Launch Template ID
# Useful for troubleshooting or creating additional ASGs with the same template
output "launch_template_id" {
  description = "ID of the launch template used by the ASG"
  value       = aws_launch_template.web_lt.id
}

# Auto Scaling Group Name
# Needed for AWS CLI commands or CloudWatch alarm configuration
output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.web_asg.name
}

# AMI ID Used
# Documents which AMI version was deployed (important for auditing)
output "ami_used" {
  description = "AMI ID used for EC2 instances"
  value       = data.aws_ami.latest_nginx_ami.id
}

# ALB DNS Name - MOST IMPORTANT OUTPUT
# This is the URL you'll use to access your application
# Example: joy-web-alb-123456789.ca-central-1.elb.amazonaws.com
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer (use this to access your app)"
  value       = aws_lb.web_alb.dns_name
}

# ALB ARN
# Amazon Resource Name - needed for IAM policies, CloudWatch, etc.
output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.web_alb.arn
}

# Production Enhancement: Add more useful outputs
# output "target_group_arn" {
#   description = "ARN of the target group"
#   value       = aws_lb_target_group.web_tg.arn
# }
#
# output "security_group_id" {
#   description = "ID of the security group"
#   value       = aws_security_group.web_sg.id
# }

