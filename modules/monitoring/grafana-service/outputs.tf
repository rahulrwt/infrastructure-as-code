output "efs_filesystem_id" {
  description = "ID of the EFS filesystem used for Grafana data"
  value       = aws_efs_file_system.grafana.id
}

output "grafana_service_name" {
  description = "Name of the Grafana ECS service"
  value       = aws_ecs_service.grafana.name
}

output "grafana_task_definition_arn" {
  description = "ARN of the Grafana task definition"
  value       = aws_ecs_task_definition.grafana.arn
}