data "aws_ami" "amazon_linux_2_ecs" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_template" "ecs_instances" {
  name                   = "${local.name_prefix}-lt"
  image_id               = data.aws_ami.amazon_linux_2_ecs.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ecs_instances.id]
  
  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }
  
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 30
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
    }
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo "ECS_CLUSTER=${aws_ecs_cluster.monitoring.name}" >> /etc/ecs/ecs.config
    
    # Install EFS utilities and NFS
    yum update -y
    yum install -y amazon-efs-utils nfs-utils
    
    # Make sure the NFS service is running
    systemctl enable nfs-utils
    systemctl start nfs-utils
    
    # Test NFS connectivity
    echo "Testing NFS connectivity" > /var/log/efs-test.log
    showmount -e >> /var/log/efs-test.log 2>&1
    
    # Create mount point directory for EFS if it doesn't exist
    mkdir -p /mnt/efs
  EOF
  )
  
  tag_specifications {
    resource_type = "instance"
    tags = merge(
      local.tags,
      {
        Name = "${local.name_prefix}-instance"
      }
    )
  }
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs_instances" {
  name                = "${local.name_prefix}-asg"
  vpc_zone_identifier = var.subnet_ids
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  
  launch_template {
    id      = aws_launch_template.ecs_instances.id
    version = "$Latest"
  }
  
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }
  
  lifecycle {
    create_before_destroy = true
  }
  
  dynamic "tag" {
    for_each = merge(
      local.tags,
      {
        Name = "${local.name_prefix}-instance"
      }
    )
    
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

# This data source allows us to retrieve public IPs of the instances
data "aws_instances" "ecs_instances" {
  depends_on = [aws_autoscaling_group.ecs_instances]
  
  filter {
    name   = "tag:aws:autoscaling:groupName"
    values = [aws_autoscaling_group.ecs_instances.name]
  }
  
  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}