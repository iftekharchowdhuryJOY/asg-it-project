output "launch_template_id" {
  value = aws_launch_template.web_lt.id
}

output "asg_name" {
  value = aws_autoscaling_group.web_asg.name
}

output "ami_used" {
  value = data.aws_ami.latest_nginx_ami.id
}
