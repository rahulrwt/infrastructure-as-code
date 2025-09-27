variable "prefix" {
  description = "Prefix to be used for resource naming to uniquely identify the environment (e.g., staging, production)"
  type        = string
  default     = ""
}

variable "rds_sg_ids" {
  description = "Security group ids for RDS"
  type = list(string)
}

variable "rds_instance_class" {
    description = "Instance class for RDS"
    type        = string
    default     = "db.t3g.micro"
}

variable "rds_disk_size" {
    description = "Disk size for RDS"
    type        = number
    default     = 150
  
}

variable "rds_subnet_group_name" {
    description = "Name of the RDS subnet group"
    type        = string
}

variable "database_name" {
    description = "Name of the database"
    type        = string
}
variable "database_username" {
    description = "Username for the database"
    type        = string
}
variable "database_password" {
    description = "Password for the database"
    type        = string
}

variable "database_disk_type" {
  description = "Disk type for the database gp2/gp3"
  default = "gp3"
}

variable "retention_period" {
  description = "Retention period for the database in days"
  type        = number
  default     = 5
  
}

variable "enable_performance_insights" {
  description = "Enable performance insights for the database"
  type        = bool
  default     = true
  
}