data "aws_region" "current" {}

resource "aws_ecs_task_definition" "prometheus" {
  family                   = "${local.name_prefix}-task"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = var.task_execution_role_arn
  task_role_arn            = var.task_role_arn
  cpu                      = var.prometheus_cpu
  memory                   = var.prometheus_memory
  
  lifecycle {
    ignore_changes = [container_definitions]                  #If there is container_defination change only terraform will not update the task defination
  }
  
  volume {
    name = "prometheus-data"
    
    efs_volume_configuration {
      file_system_id     = aws_efs_file_system.prometheus.id
      root_directory     = "/prometheus"
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = aws_efs_access_point.prometheus.id
        iam             = "ENABLED"
      }
    }
  }
  
  volume {
    name = "prometheus-config"
  }

  container_definitions = jsonencode([
    {
      name         = "prometheus-config"
      image        = "busybox:latest"
      essential    = false
      command      = ["sh", "-c", "echo '${local.prometheus_config}' > /config/prometheus.yml && cat /config/prometheus.yml"]
      mountPoints  = [
        {
          sourceVolume  = "prometheus-config"
          containerPath = "/config"
          readOnly      = false
        }
      ]
    },
    {
      name         = "prometheus"
      image        = var.prometheus_image
      essential    = true
      dependsOn    = [
        {
          containerName = "prometheus-config"
          condition     = "SUCCESS"
        }
      ]
      portMappings = [
        {
          containerPort = var.prometheus_port
          hostPort      = var.prometheus_port
          protocol      = "tcp"
        }
      ]
      mountPoints = [
        {
          sourceVolume  = "prometheus-data"
          containerPath = "/prometheus"
          readOnly      = false
        },
        {
          sourceVolume  = "prometheus-config"
          containerPath = "/etc/prometheus"
          readOnly      = true
        }
      ]
      environment = [
        {
          name  = "TZ"
          value = "UTC"
        },
        {
          name  = "AWS_REGION"
          value = data.aws_region.current.name
        }
      ]
      command = [
        "--config.file=/etc/prometheus/prometheus.yml",
        "--storage.tsdb.path=/prometheus",
        "--storage.tsdb.retention.time=${var.retention_in_days}d",
        "--web.console.libraries=/usr/share/prometheus/console_libraries",
        "--web.console.templates=/usr/share/prometheus/consoles"
      ]
    }
  ])
  
  tags = local.tags
}

resource "aws_ecs_service" "prometheus" {
  name                = "${local.name_prefix}-service"
  cluster             = var.ecs_cluster_id
  task_definition     = aws_ecs_task_definition.prometheus.arn
  desired_count       = 1
  launch_type         = "EC2"
  scheduling_strategy = "REPLICA"
  
  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }
  
  lifecycle {
    ignore_changes = [desired_count]
  }
  
  depends_on = [aws_efs_mount_target.prometheus]
  
  tags = local.tags
}