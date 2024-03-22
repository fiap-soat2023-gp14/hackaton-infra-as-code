resource "aws_db_instance" "service" {
  allocated_storage   = 10
  db_name             = "clientes"
  engine              = "postgres"
  engine_version      = "13.9"
  instance_class      = "db.t3.micro"
  username            = "fiapadmin"
  password            = var.pgsql_password
  skip_final_snapshot = true // required to destroy

  vpc_security_group_ids = [aws_security_group.pgsql-security-group-fiap-project.id]
  db_subnet_group_name   = aws_db_subnet_group.pgsql_subnet_group.name
  # Enable enhanced monitoring
  monitoring_interval = 60 # Interval in seconds (minimum 60 seconds)
  monitoring_role_arn = aws_iam_role.rds_monitoring_role.arn
}

resource "aws_db_subnet_group" "pgsql_subnet_group" {
  name       = "pgsql-subnet-group"
  subnet_ids = aws_subnet.private_subnets.*.id
}

resource "aws_iam_role" "rds_monitoring_role" {
  name = "rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "rds_monitoring_attachment" {
  name       = "rds-monitoring-attachment"
  roles      = [aws_iam_role.rds_monitoring_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
