resource "aws_route_table" "rtb-fiap-project" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gatway-fiap-project.id
  }
  tags = {
    Name = "rtb-fiap-project"
  }
}

resource "aws_route_table_association" "subnet-route-fiap-project" {
  subnet_id      = aws_subnet.private_subnets[0].id
  route_table_id = aws_route_table.rtb-fiap-project.id
}

resource "aws_route_table_association" "subnet-route-fiap-project-2" {
  subnet_id      = aws_subnet.private_subnets[1].id
  route_table_id = aws_route_table.rtb-fiap-project.id
}
