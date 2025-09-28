output "grafana_security_group_id" {
  description = "Security group ID for Grafana"
  value       = aws_security_group.grafana.id
}

output "ecs_cluster_id" {
  description = "ECS cluster ID"
  value       = aws_ecs_cluster.grafana.id
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.grafana.name
}

output "grafana_service_name" {
  description = "Name of the Grafana ECS service"
  value       = aws_ecs_service.grafana.name
}

output "efs_filesystem_id" {
  description = "ID of the EFS filesystem used for Grafana data"
  value       = aws_efs_file_system.grafana.id
}

output "grafana_instance_public_ips" {
  description = "Public IPs of the EC2 instances running Grafana"
  value       = data.aws_instances.ecs_instances.public_ips
}