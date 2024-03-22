resource "aws_appautoscaling_target" "ecs_target_timesheet" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.ecs-cluster-timesheet.name}/${aws_ecs_service.ecs-service-timesheet.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}
resource "aws_appautoscaling_policy" "ecs_timesheet_policy_memory" {
  name               = "memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target_timesheet.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target_timesheet.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target_timesheet.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 80
  }
}

resource "aws_appautoscaling_policy" "ecs_timesheet_policy_cpu" {
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target_timesheet.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target_timesheet.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target_timesheet.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 60
  }
}
