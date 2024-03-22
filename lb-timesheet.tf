resource "aws_lb" "ecs-events-lb-timesheet" {
  name               = "ecs-events-lb-timesheet"
  internal           = true
  load_balancer_type = "application"
  ip_address_type    = "ipv4"

  subnets = [for subnet in aws_subnet.public_subnets : subnet.id]


  security_groups = [
    aws_security_group.timesheet-balancer-security-group.id
  ]

  tags = {
    Name = "ecs-events-lb-timesheet"
  }

}
resource "aws_lb_target_group" "lb-target-group-timesheet" {
  name        = "lb-target-group-timesheet"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "flb-target-group-timesheet"
  }
}

resource "aws_lb_listener" "lb-listener-timesheet" {
  load_balancer_arn = aws_lb.ecs-events-lb-timesheet.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-target-group-timesheet.arn
  }

  tags = {
    Name = "lb-listener-timesheet"
  }
}


