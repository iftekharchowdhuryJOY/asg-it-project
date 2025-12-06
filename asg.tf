# Get subnets from default VPC
data "aws_subnets" "default" {
  filter {
    name   = "default-for-az"
    values = ["true"]
  }

  filter {
    name   = "availability-zone"
    values = ["ca-central-1a", "ca-central-1b"]
  }
}

resource "aws_autoscaling_group" "web_asg" {
  name                 = "joy-web-asg"
  desired_capacity     = 2
  min_size             = 2
  max_size             = 4
  vpc_zone_identifier  = data.aws_subnets.default.ids

  target_group_arns = [aws_lb_target_group.web_tg.arn]

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Joy-ASG-Web"
    propagate_at_launch = true
  }
}
