output "rds_endpoint" {
  value = aws_db_instance.rds_instance.endpoint
}

output "rds_identifier" {
  value = aws_db_instance.rds_instance.identifier
}