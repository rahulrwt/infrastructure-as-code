output "ecs_cluster_id" {
  description = "ECS cluster ID"
  value       = aws_ecs_cluster.monitoring.id
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.monitoring.name
}

output "security_group_id" {
  description = "Security group ID for the ECS instances"
  value       = aws_security_group.ecs_instances.id
}

output "instance_profile_arn" {
  description = "Instance profile ARN for the ECS instances"
  value       = aws_iam_instance_profile.ecs_instance_profile.arn
}

output "task_execution_role_arn" {
  description = "Task execution role ARN for ECS tasks"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "task_role_arn" {
  description = "Task role ARN for ECS tasks"
  value       = aws_iam_role.ecs_task_role.arn
}

output "instance_public_ips" {
  description = "Public IPs of the EC2 instances in the ECS cluster"
  value       = data.aws_instances.ecs_instances.public_ips
}

output "instance_private_ips" {
  description = "Private IPs of the EC2 instances in the ECS cluster"
  value       = data.aws_instances.ecs_instances.private_ips
}