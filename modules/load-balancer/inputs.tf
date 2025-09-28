variable "lb_sg_ids" {
  description = "Security group ids for Load Balancer"
  type = list(string)
}

variable "lb_subnet_ids" {
  description = "Subnet ids for Load Balancer"
  type = list(string)
}

variable "vpc_id" {
  description = "VPC id"
  type = string
}

variable "asg_id" {
  description = "Autoscaling group id"
  type = string
}

variable "certificate_arn" {
  description = "Certificate ARN"
  type = string
}

variable "lb_name" {
  description = "Name of the load balancer"
  type = string
}

variable "prefix" {
  description = "Prefix for resource names to uniquely identify the environment (e.g., staging, production)"
  type        = string
  default     = ""
}