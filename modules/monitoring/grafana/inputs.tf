variable "name_prefix" {
  description = "Prefix to be used for resource naming"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs where the ECS instances will be launched"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type for ECS cluster"
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "SSH key name to access EC2 instances"
  type        = string
}

variable "min_size" {
  description = "Minimum size of the ECS ASG"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum size of the ECS ASG"
  type        = number
  default     = 1
}

variable "desired_capacity" {
  description = "Desired capacity of the ECS ASG"
  type        = number
  default     = 1
}

variable "grafana_port" {
  description = "Port on which Grafana will listen"
  type        = number
  default     = 3000
}

variable "grafana_image" {
  description = "Grafana Docker image"
  type        = string
  default     = "grafana/grafana:latest"
}

variable "grafana_cpu" {
  description = "CPU units for the Grafana task"
  type        = number
  default     = 256
}

variable "grafana_memory" {
  description = "Memory for the Grafana task"
  type        = number
  default     = 512
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

variable "tags" {
  description = "Additional tags for the resources"
  type        = map(string)
  default     = {}
}