locals {
  name_prefix = var.prefix != "" ? "${var.prefix}-" : ""
}

resource "aws_db_instance" "rds_instance" {
  identifier                  = "${local.name_prefix}${var.database_name}"
  engine                      = "postgres"
  engine_version              = "16.4"
  instance_class              = var.rds_instance_class
  allocated_storage           = var.rds_disk_size
  storage_type                = var.database_disk_type
  username                    = var.database_username
  password                    = var.database_password 
  publicly_accessible         = true
  skip_final_snapshot         = true
  vpc_security_group_ids      = var.rds_sg_ids
  db_subnet_group_name        = var.rds_subnet_group_name
  auto_minor_version_upgrade  = false
  apply_immediately           = true
  backup_retention_period     = var.retention_period
  backup_window               = "21:00-22:00" # UTC → 2:30-3:30 AM IST
  maintenance_window          = "thu:22:00-thu:22:30" # Sun 03:30-04:00 AM IST
  enabled_cloudwatch_logs_exports = ["postgresql"]
  deletion_protection         = true
  copy_tags_to_snapshot       = true
  performance_insights_enabled = var.enable_performance_insights
  parameter_group_name         = var.enable_performance_insights ? aws_db_parameter_group.performance_pg.name : null

  performance_insights_retention_period = var.enable_performance_insights ? 7 : null

  tags = {
    Name       = "${local.name_prefix}${var.database_name}"
    ManagedBy  = "Terraform"
  }
}

resource "aws_db_parameter_group" "performance_pg" {
  name        = "pg16-performance-insight-group"
  family      = "postgres16"
  description = "Parameter group for PostgreSQL 16.4 with Performance Insights optimization"

  parameter {
    name  = "track_io_timing"
    value = "1"
  }

  parameter {
    name  = "log_min_duration_statement"
    value = "500" # Log queries slower than 500ms
  }

  parameter {
    name  = "log_checkpoints"
    value = "1"
  }

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  parameter {
    name  = "log_lock_waits"
    value = "1"
  }

  parameter {
    name  = "log_temp_files"
    value = "0" # Log all temp file creation
  }

  parameter {
    name  = "log_statement"
    value = "none" # Change to "all" or "mod" for debugging
  }

  parameter {
    name  = "auto_explain.log_min_duration"
    value = "500"
  }
}
