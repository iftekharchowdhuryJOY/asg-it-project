# ============================================================================
# ALB Listener
# ============================================================================
# Purpose: Defines HOW the ALB listens for and routes incoming traffic
# 
# What is a Listener?
# - Checks for connection requests using the protocol and port you configure
# - Routes requests to target groups based on rules
# - Can have multiple listeners (e.g., HTTP on 80, HTTPS on 443)
# 
# Traffic Flow:
# Client Request → ALB:80 (Listener) → Target Group → EC2 Instances
# ============================================================================

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.web_alb.arn # Which ALB to attach this listener to
  port              = 80 # Listen on HTTP port
  protocol          = "HTTP" # HTTP protocol (use HTTPS for production)

  # Default Action: What to do with requests that match this listener
  # In this case, forward all HTTP traffic to the target group
  default_action {
    type             = "forward" # Forward traffic to target group
    target_group_arn = aws_lb_target_group.web_tg.arn # Where to send traffic
  }

  # Production Enhancement: Add HTTPS listener
  # resource "aws_lb_listener" "https_listener" {
  #   load_balancer_arn = aws_lb.web_alb.arn
  #   port              = 443
  #   protocol          = "HTTPS"
  #   ssl_policy        = "ELBSecurityPolicy-2016-08"
  #   certificate_arn   = aws_acm_certificate.cert.arn
  #   default_action {
  #     type             = "forward"
  #     target_group_arn = aws_lb_target_group.web_tg.arn
  #   }
  # }
}
