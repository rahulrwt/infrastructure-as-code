# Output Bucket Name
output "app_object_bucket_name" {
  value = aws_s3_bucket.app-objects.id
}

output "app_public_object_bucket_name" {
  value = aws_s3_bucket.app-public-objects.id
}

output "dashboard_bucket_name" {
  value = var.create_dashboard_bucket ? aws_s3_bucket.app-deployment-dashboard[0].id : null
}

output "dashboard_website_url" {
  value = var.create_dashboard_bucket ? aws_s3_bucket_website_configuration.dashboard_website[0].website_endpoint : null
}
