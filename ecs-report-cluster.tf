resource "aws_ecs_cluster" "ecs-cluster-report" {
  name = "ecs-cluster-report"
}

resource "aws_ecs_cluster_capacity_providers" "ecs-cluster-report" {
  cluster_name = aws_ecs_cluster.ecs-cluster-report.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 0
    weight            = 1
    capacity_provider = "FARGATE"
  }
}