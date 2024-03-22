resource "aws_ecs_service" "ecs-service-timesheet" {
  name            = "ecs-service-timesheet"
  cluster         = aws_ecs_cluster.ecs-cluster-timesheet.id
  task_definition = aws_ecs_task_definition.ecs-td-fiap-timesheet.arn
  desired_count   = 1
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
    base = 0
  }
  scheduling_strategy                = "REPLICA"

  network_configuration {
    subnets         = "${aws_subnet.private_subnets.*.id}"
    security_groups = [aws_security_group.timesheet-security-group.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.lb-target-group-timesheet.arn
    container_name   = "ecr-fiap-hacka-time-sheet"
    container_port   = 8080
  }
}
