resource "aws_ecs_cluster" "ecs-cluster-timesheet" {
  name = "ecs-cluster-timesheet"
}

resource "aws_ecs_cluster_capacity_providers" "ecs-cluster-timesheet" {
  cluster_name = aws_ecs_cluster.ecs-cluster-timesheet.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 0
    weight            = 1
    capacity_provider = "FARGATE"
  }
}