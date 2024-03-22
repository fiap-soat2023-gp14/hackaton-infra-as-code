resource "aws_security_group" "timesheet-security-group" {
  name        = "timesheet-security-group"
  description = "Security group for timesheet"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "timesheet-security-group"
  }

  ingress {
    description     = "HTTP from balancer timesheet security group"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.timesheet-balancer-security-group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
