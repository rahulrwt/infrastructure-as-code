output "efs_filesystem_id" {
  description = "ID of the EFS filesystem used for Prometheus data"
  value       = aws_efs_file_system.prometheus.id
}

output "prometheus_service_name" {
  description = "Name of the Prometheus ECS service"
  value       = aws_ecs_service.prometheus.name
}

output "prometheus_task_definition_arn" {
  description = "ARN of the Prometheus task definition"
  value       = aws_ecs_task_definition.prometheus.arn
}