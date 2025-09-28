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

variable "instance_type" {
  description = "EC2 instance type for ECS cluster"
  type        = string
  default     = "t3.micro"
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
  default     = 2
}

variable "desired_capacity" {
  description = "Desired capacity of the ECS ASG"
  type        = number
  default     = 1
}

# Prometheus variables
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
  default     = 512
}

variable "prometheus_memory" {
  description = "Memory for the Prometheus task"
  type        = number
  default     = 1024
}

variable "prometheus_retention_days" {
  description = "Number of days to retain Prometheus data"
  type        = number
  default     = 7
}


# Grafana variables
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

# Common variables
variable "efs_throughput_mode" {
  description = "Throughput mode for the EFS file system"
  type        = string
  default     = "bursting"
}

variable "tags" {
  description = "Additional tags for the resources"
  type        = map(string)
  default     = {}
}