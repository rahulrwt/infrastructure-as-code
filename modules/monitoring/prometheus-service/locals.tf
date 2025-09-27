locals {
  name_prefix = "${var.name_prefix}-prometheus"
  tags = merge(
    {
      Name      = local.name_prefix
      ManagedBy = "Terraform"
    },
    var.tags
  )
  
  # Prometheus config
  prometheus_config = templatefile("${path.module}/templates/prometheus.yml.tpl", {
    retention_time        = "${var.retention_in_days}d"
    aws_region           = data.aws_region.current.name
    app_name             = var.app_name
    asg_name             = var.asg_name
    metrics_path         = var.metrics_path
    scrape_interval      = var.scrape_interval
    basic_auth_username  = var.basic_auth_username
    basic_auth_password  = var.basic_auth_password
    target_port          = var.target_port
  })
}