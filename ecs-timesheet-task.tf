resource "aws_ecs_task_definition" "ecs-td-fiap-timesheet" {
  family       = "ecs-td-fiap-timesheet"
  network_mode = "awsvpc"
  cpu          = 512
  memory = 2048
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name   = "ecr-fiap-hacka-time-sheet"
      image  = "${var.ecr_repository_code}.dkr.ecr.us-east-1.amazonaws.com/ecr-fiap-hacka-time-sheet:latest"
      essential = true
      cpu          = 512
      memory = 2048
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "MONGODB_CONNECTION_STRING"
          value = "mongodb://${aws_docdb_cluster.service.master_username}:${aws_docdb_cluster.service.master_password}@${aws_docdb_cluster.service.endpoint}:${aws_docdb_cluster.service.port}/fiapHackaton?tls=true&retryWrites=false"
        },
        {
          name  = "CLUSTER_URL"
          value = "${aws_apigatewayv2_api.apigw_http_endpoint.api_endpoint}"
        },
         {
          name  = "AWS_REGION"
          value = "${var.region}"        
        },
        {
          name  = "AWS_REPORT_QUEUE"
          value = "${aws_sqs_queue.report_request_queue.name}"        
        },
        {
          name  = "AWS_PEDIDOS_QUEUE_URL"
          value =  "${aws_sqs_queue.report_request_queue.id}"        
        }
      ]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.default.name,
          awslogs-region        = var.region,
          awslogs-stream-prefix = "app",
          awslogs-create-group  = "true"
        }
      }
    }
  ])
}
