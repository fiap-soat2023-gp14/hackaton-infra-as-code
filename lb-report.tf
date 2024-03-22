resource "aws_lb" "ecs-events-lb-report" {
  name               = "ecs-events-lb-report"
  internal           = true
  load_balancer_type = "application"
  ip_address_type    = "ipv4"

  subnets = [for subnet in aws_subnet.public_subnets : subnet.id]


  security_groups = [
    aws_security_group.report-balancer-security-group.id
  ]

  tags = {
    Name = "ecs-events-lb-report"
  }

}
resource "aws_lb_target_group" "lb-target-group-report" {
  name        = "lb-target-group-report"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "flb-target-group-report"
  }
}

resource "aws_lb_listener" "lb-listener-report" {
  load_balancer_arn = aws_lb.ecs-events-lb-report.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-target-group-report.arn
  }

  tags = {
    Name = "lb-listener-report"
  }
}


