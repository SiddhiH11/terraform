resource "aws_lb_target_group" "home_target_group" {
    name = "${var.project}-${var.env}-home-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id
    health_check {
        enabled = true
        path = "/"
        port = "traffic-port"
        protocol = "HTTP"       
    }
}

resource "aws_lb_target_group" "mobile_target_group" {
    name = "${var.project}-${var.env}-mobile-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id
    health_check {
        enabled = true
        path = "/mobile/"
        port = "traffic-port"
        protocol = "HTTP"       
    }
}

resource "aws_lb_target_group" "laptop_target_group" {
    name = "${var.project}-${var.env}-laptop-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id
    health_check {
        enabled = true
        path = "/laptop/"
        port = "traffic-port"
        protocol = "HTTP"       
    }
}