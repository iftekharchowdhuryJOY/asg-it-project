# ============================================================================
# Auto Scaling Policy
# ============================================================================
# Purpose: Automatically adjusts the number of EC2 instances based on demand
# 
# What is Target Tracking Scaling?
# - Automatically increases/decreases capacity to maintain a target metric value
# - Similar to a thermostat: set a target, and it adjusts to maintain it
# - Simpler than step scaling or simple scaling policies
# 
# How it works:
# 1. CloudWatch monitors the specified metric (CPU utilization)
# 2. If metric exceeds target, ASG launches more instances
# 3. If metric falls below target, ASG terminates instances
# 4. Respects min_size and max_size constraints
# ============================================================================

resource "aws_autoscaling_policy" "cpu_scaling" {
  name                   = "cpu-target-tracking-scaling"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  policy_type            = "TargetTrackingScaling"

  # Target Tracking Configuration
  # Maintains average CPU utilization at the specified target value
  target_tracking_configuration {
    predefined_metric_specification {
      # Monitor average CPU utilization across all instances in the ASG
      predefined_metric_type = "ASGAverageCPUUtilization"
      
      # NOTE: resource_label is NOT needed for ASGAverageCPUUtilization
      # It's only used for ALBRequestCountPerTarget metric
      # Removing this line to fix the configuration
    }

    # Target Value: Desired average CPU utilization percentage
    # When average CPU exceeds 70%, scale OUT (add instances)
    # When average CPU falls below 70%, scale IN (remove instances)
    target_value = 70.0 # Percentage (was incorrectly set to 200)

    # Scale-in Configuration
    # Disable scale-in if you want to manually control instance termination
    # disable_scale_in = false
  }

  # Best Practice: Add cooldown periods to prevent flapping
  # This is handled automatically by target tracking, but can be customized
}

# Alternative: Request Count Per Target Scaling
# Uncomment this to scale based on ALB request count instead of CPU
# resource "aws_autoscaling_policy" "request_count_scaling" {
#   name                   = "request-count-scaling"
#   autoscaling_group_name = aws_autoscaling_group.web_asg.name
#   policy_type            = "TargetTrackingScaling"
#
#   target_tracking_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ALBRequestCountPerTarget"
#       resource_label         = "${aws_lb.web_alb.arn_suffix}/${aws_lb_target_group.web_tg.arn_suffix}"
#     }
#     target_value = 1000.0 # Target 1000 requests per instance
#   }
# }