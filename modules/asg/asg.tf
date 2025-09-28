resource "aws_autoscaling_group" "app-server-asg" {
  name = local.asg_name

  vpc_zone_identifier = var.subnet_ids
  termination_policies = ["OldestInstance"]
  default_cooldown = 60
  
  # Add a termination hook to ensure our shutdown script runs
  initial_lifecycle_hook {
    name                 = "upload-logs-on-terminate"
    default_result       = "CONTINUE"
    heartbeat_timeout    = 180
    lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
  }
  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 1       # Minimum On-Demand instances
      on_demand_percentage_above_base_capacity = 50      # 50% of instances are On-Demand
      spot_allocation_strategy                 = "lowest-price"  # Spot instance allocation strategy
      spot_max_price = local.max_bid
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.app_server_template.id
        version            = "$Latest"
      }

      # override {
      #   instance_type = local.spot_instance_option  # Define additional instance types for flexibility
      # }
    }
  }

  min_size         = 1
  max_size         = 2
  desired_capacity  = 1
  health_check_type = "EC2"
  health_check_grace_period = 360
  target_group_arns = var.target_group_arns
  tag {
    key                 = "ManagedBy"
    value               = "Terraform"
    propagate_at_launch = true
  }
}
