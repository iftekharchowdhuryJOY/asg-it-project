# AWS Auto Scaling Group (ASG) IT Project

## Overview

This project uses Terraform to provision a complete AWS Auto Scaling Group (ASG) environment. It includes all the core components needed to automatically scale EC2 instances based on demand, using a launch template, AMI data, security configuration, and outputs for integration.

---

## Core Components

- **provider.tf**  
  Configures the AWS provider with default settings.

- **ami-data.tf**  
  Retrieves and manages the Amazon Machine Image (AMI) data used for EC2 instances in the Auto Scaling Group.

- **launch_template.tf**  
  Defines the AWS Launch Template that specifies the configuration for EC2 instances launched by the ASG (such as AMI, instance type, security groups, and user data).

- **asg.tf**  
  Provisions the Auto Scaling Group, linking the launch template, specifying scaling policies, target group associations, minimum and maximum sizes, and availability zones.

- **security.tf**  
  Sets up required security resources, such as security groups for EC2 instances managed by the ASG.

- **variables.tf**  
  Contains all input variables to parameterize the infrastructure (e.g., AMI ID, instance types, group sizes).

- **outputs.tf**  
  Exposes useful outputs like the Auto Scaling Group name, Launch Template ID, or instance IPs to facilitate downstream automation or resource integration.

---

## Getting Started

### Prerequisites

- Terraform CLI (v1.0+ recommended)
- AWS CLI configured with appropriate permissions

### Usage

1. **Clone the repository**
   ```bash
   git clone https://github.com/iftekharchowdhuryJOY/asg-it-project.git
   cd asg-it-project
   ```
2. **Review and update `terraform.tfvars` or set variables via CLI/environment as required.**
3. **Initialize Terraform**
   ```bash
   terraform init
   ```
4. **Review planned actions**
   ```bash
   terraform plan
   ```
5. **Apply changes**
   ```bash
   terraform apply
   ```

---

## Customization

Edit the `variables.tf` and `terraform.tfvars` to adjust parameters such as:

- AMI ID
- Instance type
- Desired/min/max capacities
- VPC and subnet settings
- Security group rules

---

## Outputs

After deployment, useful resource identifiers and endpoints are available in `outputs.tf`. Use these outputs to integrate your ASG with monitoring, load balancers, or other AWS services.

---

## Security

- Security groups restrict instance access; review and tailor as needed.
- AMI selection and updates are automated but validate for compliance and patch status.
- Limit user privileges in AWS for the Terraform execution environment.

---

## Additional Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [AWS Auto Scaling Groups](https://docs.aws.amazon.com/autoscaling/ec2/userguide/AutoScalingGroup.html)
- [AWS Launch Templates](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-launch-templates.html)

---
*Professional infrastructure-as-code example for scalable EC2 management in AWS.*