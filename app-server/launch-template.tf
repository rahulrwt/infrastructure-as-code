resource "aws_launch_template" "app-server-template" {
  name          = "app-server-launch-template"
  image_id      = local.app-server-ami
  instance_type = local.instance_type
  key_name      = local.aws-key-pair-name
  user_data = base64encode(local.user_data_script)  
  # latest_version = true
  network_interfaces {
    security_groups = [aws_security_group.cooking-corner-sg.id]
  }
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 8
      volume_type = "gp2"
    }
  }
    tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "application-server"
    }
  }
}