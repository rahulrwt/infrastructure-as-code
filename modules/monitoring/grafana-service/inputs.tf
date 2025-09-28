variable "name_prefix" {
  description = "Prefix to be used for resource naming"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs where the ECS instances will be launched"
  type        = list(string)
}

variable "ecs_cluster_id" {
  description = "ECS cluster ID where the service will be deployed"
  type        = string
}

variable "ecs_security_group_id" {
  description = "Security group ID for the ECS instances"
  type        = string
}

variable "task_execution_role_arn" {
  description = "Task execution role ARN for the ECS tasks"
  type        = string
}

variable "task_role_arn" {
  description = "Task role ARN for the ECS tasks"
  type        = string
}

variable "grafana_port" {
  description = "Port on which Grafana will listen"
  type        = number
  default     = 3000
}

variable "grafana_image" {
  description = "Grafana Docker image"
  type        = string
  default     = "grafana/grafana:10.0.3"
}

variable "grafana_cpu" {
  description = "CPU units for the Grafana task"
  type        = number
  default     = 128
}

variable "grafana_memory" {
  description = "Memory for the Grafana task"
  type        = number
  default     = 256
}

variable "efs_throughput_mode" {
  description = "Throughput mode for the EFS file system"
  type        = string
  default     = "bursting"
}

variable "efs_provisioned_throughput" {
  description = "Provisioned throughput for the EFS file system (in MiB/s)"
  type        = number
  default     = null
}

variable "prometheus_endpoint" {
  description = "Endpoint for the Prometheus instance"
  type        = string
}

variable "admin_user" {
  description = "Admin user for Grafana"
  type        = string
  default     = "admin"
}

variable "admin_password" {
  description = "Admin password for Grafana"
  type        = string
  default     = "admin"
}

variable "smtp_host" {
  description = "SMTP server host for Grafana notifications"
  type        = string
  default     = ""
}

variable "smtp_port" {
  description = "SMTP server port for Grafana notifications"
  type        = number
  default     = 587
}

variable "smtp_from_address" {
  description = "From email address for Grafana notifications"
  type        = string
  default     = ""
}

variable "smtp_user" {
  description = "SMTP username for Grafana notifications"
  type        = string
  default     = ""
}

variable "smtp_password" {
  description = "SMTP password for Grafana notifications"
  type        = string
  default     = ""
  sensitive   = true
}

variable "tags" {
  description = "Additional tags for the resources"
  type        = map(string)
  default     = {}
}