resource "aws_launch_template" "web_lt" {
  name_prefix   = "joy-web-lt-"
  image_id      = data.aws_ami.latest_nginx_ami.id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.web_sg.id]
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras install nginx1 -y
    systemctl enable nginx
    systemctl start nginx
  EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Joy-ASG-Instance"
    }
  }
}
