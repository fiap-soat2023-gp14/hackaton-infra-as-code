resource "aws_security_group" "report-security-group" {
  name        = "report-security-group"
  description = "Security group for report"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "report-security-group"
  }

  ingress {
    description     = "HTTP from balancer report security group"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.report-balancer-security-group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
