resource "aws_security_group" "docdb-security-group-fiap-project" {
  name        = "docdb-security-group-fiap-project"
  description = "Security group for cluster"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "docdb-security-group-fiap-project"
  }

  ingress {
    description     = "Connecting to DocDB with ECS"
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
