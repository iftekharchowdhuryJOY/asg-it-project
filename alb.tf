resource "aws_lb" "web_alb" {
    name               = "joy-web-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.web_sg.id]
    subnets            = data.aws_subnets.default.ids
}

