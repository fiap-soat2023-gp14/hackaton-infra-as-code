# Generated API GW endpoint URL that can be used to access the application running on a private ECS Fargate cluster.
output "apigw_endpoint_service_url" {
  value = aws_apigatewayv2_api.apigw_http_endpoint.api_endpoint
  description = "API Gateway Services"
}

output "apigw_endpoint_auth_url" {
  value = aws_api_gateway_deployment.apigw-lambda-fiap-project.invoke_url
  description = "API Gateway Auth URL"
}