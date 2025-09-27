variable "instance-type" {
  description = "Instance type of server"
  type        = string
  default     = "t3.small"
}

variable "app-server-ami" {
  description = "AMI to be used by the app server"
  type = string
  default = "ami-064519b8c76274859"
}

variable "aws-key-pair-name" {
  description = "AWS key to be assigend to the app-server"
  type = string
  default = "rahul-ssh"
}

variable "aws_region" {
  description = "Region in which resource will be created"
  type = string
  default = "us-east-1"
}

variable "max_bid" {
  description = "Max cost to pay for spot instance per hour"
  type = string
  default = "0.0112"
}

variable "spot_instance_option" {
  description = "Instance type for spot if primary isnt available"
  type = string
  default = "t3.small"
}

variable "certificate_arn" {
  description = "Certificate ARN for the load balancer"
  type = string
  default = ""
}

variable "environment_type" {
  description = "Environment type (e.g., dev, prod)"
  type        = string
  default     = "staging"
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "staging"
  
}

variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "trailandtale"
}