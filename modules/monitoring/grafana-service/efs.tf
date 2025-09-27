resource "aws_efs_file_system" "grafana" {
  creation_token = "${local.name_prefix}-data"
  encrypted      = true
  
  throughput_mode                 = var.efs_throughput_mode
  provisioned_throughput_in_mibps = var.efs_provisioned_throughput
  
  tags = local.tags
}

resource "aws_efs_mount_target" "grafana" {
  count           = length(var.subnet_ids)
  file_system_id  = aws_efs_file_system.grafana.id
  subnet_id       = var.subnet_ids[count.index]
  security_groups = [var.ecs_security_group_id]
}

resource "aws_efs_access_point" "grafana" {
  file_system_id = aws_efs_file_system.grafana.id
  
  posix_user {
    gid = 0 # root
    uid = 0 # root
  }
  
  root_directory {
    path = "/grafana"
    creation_info {
      owner_gid   = 0
      owner_uid   = 0
      permissions = "777"
    }
  }
  
  tags = local.tags
}