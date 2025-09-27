resource "aws_launch_template" "app_server_template" {
  name          = local.launch_template_name
  image_id      = var.app-server-ami
  instance_type = local.instance_type
  key_name      = var.aws-key-pair-name
  user_data     = base64encode(local.user_data_script)  
  
  iam_instance_profile {
    name = var.iam_instance_profile_name
  }
  # latest_version = true
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 8
      volume_type = "gp3"
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = var.asg_sg_ids
  }

    tag_specifications {
    resource_type = "instance"
    tags = {
      Name = local.instance_name
    }
  }
}