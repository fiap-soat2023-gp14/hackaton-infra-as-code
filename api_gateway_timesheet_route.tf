
resource "aws_apigatewayv2_integration" "apigw_timesheet" {
  api_id           = aws_apigatewayv2_api.apigw_http_endpoint.id
  integration_type = "HTTP_PROXY"
  integration_uri  = aws_lb_listener.lb-listener-timesheet.arn

  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.vpclink_apigw_to_alb.id
  payload_format_version = "1.0"
  depends_on      = [aws_apigatewayv2_vpc_link.vpclink_apigw_to_alb,
    aws_apigatewayv2_api.apigw_http_endpoint,
    aws_lb_listener.lb-listener-timesheet]
}

resource "aws_apigatewayv2_route" "apigw_timesheet_route" {
  api_id    = aws_apigatewayv2_api.apigw_http_endpoint.id
  route_key = "ANY /time-sheet/{proxy+}"
  target = "integrations/${aws_apigatewayv2_integration.apigw_timesheet.id}"
  authorization_type = "JWT"
  authorizer_id = aws_apigatewayv2_authorizer.fiap-authorizer.id
  depends_on  = [aws_apigatewayv2_integration.apigw_timesheet]
}

resource "aws_apigatewayv2_route" "apigw_timesheet_route2" {
  api_id    = aws_apigatewayv2_api.apigw_http_endpoint.id
  route_key = "ANY /time-sheet"
  target = "integrations/${aws_apigatewayv2_integration.apigw_timesheet.id}"
  authorization_type = "JWT"
  authorizer_id = aws_apigatewayv2_authorizer.fiap-authorizer.id
  depends_on  = [aws_apigatewayv2_integration.apigw_timesheet]
}


