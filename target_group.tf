resource "aws_lb_target_group" "web_tg" {
    name               = "joy-web-tg"
    port               = 80
    protocol           = "HTTP"
    target_type        = "instance"
    vpc_id             = data.aws_subnets.default.vpc_id

    health_check {
        path = "/"
        port = "80"
    }
}
