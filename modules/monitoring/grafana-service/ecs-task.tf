data "aws_region" "current" {}

resource "aws_ecs_task_definition" "grafana" {
  family                   = "${local.name_prefix}-task"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = var.task_execution_role_arn
  task_role_arn            = var.task_role_arn
  cpu                      = var.grafana_cpu
  memory                   = var.grafana_memory
  
  volume {
    name = "grafana-data"
    
    efs_volume_configuration {
      file_system_id     = aws_efs_file_system.grafana.id
      root_directory     = "/grafana"
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = aws_efs_access_point.grafana.id
        iam             = "ENABLED"
      }
    }
  }
  
  volume {
    name = "grafana-provisioning"
  }
  
  container_definitions = jsonencode([
    {
      name         = "grafana-init"
      image        = "busybox:latest"
      essential    = false
      command      = [
        "sh", 
        "-c", 
        <<-EOT
          mkdir -p /provisioning/datasources && cat > /provisioning/datasources/prometheus.yaml << 'EOF'
apiVersion: 1
datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: ${var.prometheus_endpoint}
    isDefault: true
EOF
        EOT
      ]
      mountPoints  = [
        {
          sourceVolume  = "grafana-provisioning"
          containerPath = "/provisioning"
          readOnly      = false
        }
      ]
    },
    {
      name         = "grafana"
      image        = var.grafana_image
      essential    = true
      user         = "root"
      dependsOn    = [
        {
          containerName = "grafana-init"
          condition     = "SUCCESS"
        }
      ]
      portMappings = [
        {
          containerPort = var.grafana_port
          hostPort      = var.grafana_port
          protocol      = "tcp"
        }
      ]
      mountPoints = [
        {
          sourceVolume  = "grafana-data"
          containerPath = "/var/lib/grafana"
          readOnly      = false
        },
        {
          sourceVolume  = "grafana-provisioning"
          containerPath = "/etc/grafana/provisioning"
          readOnly      = true
        }
      ]
      environment = concat(
        [
          {
            name  = "GF_SECURITY_ADMIN_USER"
            value = var.admin_user
          },
          {
            name  = "GF_SECURITY_ADMIN_PASSWORD"
            value = var.admin_password
          },
          {
            name  = "GF_INSTALL_PLUGINS"
            value = "grafana-clock-panel,grafana-simple-json-datasource"
          },
          {
            name  = "GF_PATHS_DATA"
            value = "/var/lib/grafana"
          },
          {
            name  = "GF_PATHS_LOGS"
            value = "/var/lib/grafana/logs"
          },
          {
            name  = "GF_PATHS_PLUGINS"
            value = "/var/lib/grafana/plugins"
          },
          {
            name  = "TZ"
            value = "UTC"
          },
          {
            name  = "AWS_REGION"
            value = data.aws_region.current.name
          },
          {
            name  = "GF_SMTP_ENABLED"
            value = var.smtp_host != "" ? "true" : "false"
          }
        ],
        var.smtp_host != "" ? [
          {
            name  = "GF_SMTP_HOST"
            value = "${var.smtp_host}:${var.smtp_port}"
          },
          {
            name  = "GF_SMTP_PORT"
            value = tostring(var.smtp_port)
          },
          {
            name  = "GF_SMTP_FROM_ADDRESS"
            value = var.smtp_from_address
          },
          {
            name  = "GF_SMTP_FROM_NAME"
            value = "Grafana"
          },
          {
            name  = "GF_SMTP_STARTTLS_POLICY"
            value = "MandatoryStartTLS"
          },
          {
            name  = "GF_SMTP_USER"
            value = var.smtp_user
          },
          {
            name  = "GF_SMTP_PASSWORD"
            value = var.smtp_password
          },
          {
            name  = "GF_SMTP_SKIP_VERIFY"
            value = "true"
          }
        ] : []
      )
    }
  ])
  
  tags = local.tags
}

resource "aws_ecs_service" "grafana" {
  name                = "${local.name_prefix}-service"
  cluster             = var.ecs_cluster_id
  task_definition     = aws_ecs_task_definition.grafana.arn
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
  
  depends_on = [aws_efs_mount_target.grafana]
  
  tags = local.tags
}