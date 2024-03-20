resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc-fiap-project-hackaton"
  }
  enable_dns_hostnames = true
  enable_dns_support = true
}
