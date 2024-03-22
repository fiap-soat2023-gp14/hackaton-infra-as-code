resource "aws_apigatewayv2_vpc_link" "vpclink_apigw_to_alb" {
  name        = "vpclink_apigw_to_alb"
  security_group_ids = []
  subnet_ids = "${aws_subnet.private_subnets.*.id}"
}

# Create the API Gateway HTTP endpoint
resource "aws_apigatewayv2_api" "apigw_http_endpoint" {
  name          = "fiap-pvt-endpoint"
  protocol_type = "HTTP"
}

# Set a default stage
resource "aws_apigatewayv2_stage" "apigw_stage" {
  api_id = aws_apigatewayv2_api.apigw_http_endpoint.id
  name   = "$default"
  auto_deploy = true
  depends_on  = [aws_apigatewayv2_api.apigw_http_endpoint]
}

