resource "aws_security_group" "report-balancer-security-group" {
  name        = "report-balancer-security-group"
  description = "Security group for balancer"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "report-balancer-security-group"
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}