variable "instance_type" {
  description = "Instance type of server"
  type        = string
  default     = "t2.micro"
}

variable "aws_key_pair_name" {
  description = "Key Pair name used for creating EC2 instance"
  type        = string
}