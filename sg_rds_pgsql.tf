resource "aws_security_group" "pgsql-security-group-fiap-project" {
  name        = "pgsql-security-group-fiap-project-hackaton"
  description = "Security group for pgsql"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "pgsql-security-group-fiap-project-hackaton"
  }

  ingress {
    description     = "Connecting to PGSQL with ECS"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.client-security-group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
