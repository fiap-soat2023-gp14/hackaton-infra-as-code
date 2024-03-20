resource "aws_internet_gateway" "internet-gatway-fiap-project" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "internet-gatway-fiap-project-hackaton"
  }
}
