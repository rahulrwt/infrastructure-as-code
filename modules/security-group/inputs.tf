variable "vpc_id" {
  description = "VPC id"
  type = string
}

variable "prefix" {
  description = "Prefix to be used for resource naming to uniquely identify the environment (e.g., staging, production)"
  type        = string
  default     = ""
}