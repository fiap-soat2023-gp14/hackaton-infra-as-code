resource "aws_apigatewayv2_authorizer" "fiap-authorizer" {
  api_id = "${aws_apigatewayv2_api.apigw_http_endpoint.id}"
  name                   = "${var.name}-authorizer"
  authorizer_type = "JWT"
  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    issuer = "https://cognito-idp.us-east-1.amazonaws.com/${aws_cognito_user_pool.user-pool.id}"
    audience = ["${aws_cognito_user_pool_client.client.id}"]
  }
}