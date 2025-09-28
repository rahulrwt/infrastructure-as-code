locals {
  instance_type             = var.instance-type
  region                    = var.aws_region
  user_data_script          = templatefile("${path.module}/scripts/environment-setup.sh", {
    environment             = lower(var.environment_type),
    app_name                = var.app_name,  
    env_vars_script         = local.env_vars_script
  })
  max_bid                   = var.max_bid
  spot_instance_option      = var.spot_instance_option
  
  # Resource naming with prefix
  name_prefix               = var.prefix != "" ? "${var.prefix}-" : ""
  asg_name                  = var.asg_name != "" ? "${local.name_prefix}${var.asg_name}" : "${local.name_prefix}app-server-asg"
  launch_template_name      = "${local.name_prefix}app-server-launch-template"
  instance_name             = "${local.name_prefix}application-server"

  # Set Environment Variables for the application.config
  env_vars_script           = templatefile("${path.module}/scripts/env-vars.sh", {
    s3_region        = var.s3_region,
    s3_access_key    = var.s3_access_key,
    s3_secret_key    = var.s3_secret_key
  })
}
