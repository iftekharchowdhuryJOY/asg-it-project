# ============================================================================
# Input Variables
# ============================================================================
# Purpose: Defines configurable parameters for the infrastructure
# 
# These variables allow customization without modifying the core code.
# Override defaults using terraform.tfvars or -var flags
# ============================================================================

variable "instance_type" {
  description = "Instance type for ASG EC2 instances"
  default     = "t2.micro" # Free tier eligible - suitable for testing/dev
  type        = string

  # Production recommendation: Consider t3.small or larger for better performance
  # Ensure the instance type is available in your selected AZs
}
