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
  default     = "t3.medium"
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

variable "prometheus_port" {
  description = "Port on which Prometheus will listen"
  type        = number
  default     = 9090
}

variable "grafana_port" {
  description = "Port on which Grafana will listen"
  type        = number
  default     = 3000
}

variable "tags" {
  description = "Additional tags for the resources"
  type        = map(string)
  default     = {}
}