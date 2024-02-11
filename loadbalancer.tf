resource "aws_lb_target_group" "demo" {
  name        = "demo-targets"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_security_group" "demo_lb" {
  name        = "demo-lb"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.default.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_lb" "demo" {
  name               = "demo"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.demo_lb.id]
  subnets            = data.aws_subnets.all.ids
}

resource "aws_lb_listener" "demo_https" {
  load_balancer_arn = aws_lb.demo.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.demo.arn
  }

  mutual_authentication {
    mode            = "verify"
    trust_store_arn = aws_lb_trust_store.demo.arn
  }
}