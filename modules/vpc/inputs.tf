variable "region" {
  description = "Region in which resource will be created"
  type = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC "
  type = string
}

variable "lb_subnet_cidr_1" {
  description = "CIDR block for load balancer subnet 1"
  type = string
  default = ""
}

variable "backend_subnet_cidr" {
  description = "CIDR block for backend subnet"
  type = string
  default = ""
}

variable "rds_subnet_cidr" {
  description = "CIDR block for RDS subnet"
  type = string
  default = ""
}

variable "ecs_cluster_subnet_cidr" {
  description = "CIDR block for ecs cluster subnet"
  type = string
  default = ""
}

variable "lb_subnet_cidr_2" {
  description = "CIDR block for load balancer subnet 2"
  type = string
  default = ""
}

variable "rds_subnet_cidr_1" {
  description = "CIDR block for RDS subnet 1"
  type = string
  default = ""
}

variable "rds_subnet_cidr_2" {
  description = "CIDR block for RDS subnet 2"
  type = string
  default = ""
}


variable "map_public_ip" {
  description = "Whether to map public IP on subnet launch"
  type = bool
  default = true
}

variable "subnet_name_tags" {
  description = "Tags for subnet names"
  type = map(string)
  default = {
    lb = "public-subnet"
    rds1 = "rds-subnet-1"
    rds2 = "rds-subnet-2"
    backend = "public-subnet"
    rds = "public-subnet"
    frontend = "public-subnet"
  }
}

variable "rds_subnet_group_name" {
  description = "Name for the RDS subnet group"
  type = string
  default = "rds-subnet-group"
}