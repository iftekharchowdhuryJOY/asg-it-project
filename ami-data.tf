data "aws_ami" "latest_nginx_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]   # Change prefix if your AMI name differs
  }

  owners = ["amazon"]  # Only your AWS account
}
