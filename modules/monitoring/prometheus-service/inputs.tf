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

variable "retention_in_days" {
  description = "Number of days to retain Prometheus data"
  type        = number
  default     = 7
}

variable "prometheus_port" {
  description = "Port on which Prometheus will listen"
  type        = number
  default     = 9090
}

variable "prometheus_image" {
  description = "Prometheus Docker image"
  type        = string
  default     = "prom/prometheus:v2.45.0"
}

variable "prometheus_cpu" {
  description = "CPU units for the Prometheus task"
  type        = number
  default     = 128
}

variable "prometheus_memory" {
  description = "Memory for the Prometheus task"
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


variable "tags" {
  description = "Additional tags for the resources"
  type        = map(string)
  default     = {}
}

variable "app_name" {
  description = "Application name for resource naming"
  type        = string
}

variable "asg_name" {
  description = "Auto Scaling Group name to monitor"
  type        = string
}

variable "metrics_path" {
  description = "Path for scraping metrics"
  type        = string
  default     = "/actuator/prometheus"
}

variable "scrape_interval" {
  description = "Interval for scraping metrics"
  type        = string
  default     = "15s"
}

variable "basic_auth_username" {
  description = "Basic auth username for metrics endpoint"
  type        = string
  default     = "actu@t0r"
}

variable "basic_auth_password" {
  description = "Basic auth password for metrics endpoint"
  type        = string
  default     = "d0ntH@ckM3"
  sensitive   = true
}

variable "target_port" {
  description = "Target port for application metrics"
  type        = string
  default     = "8080"
}