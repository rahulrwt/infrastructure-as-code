resource "aws_efs_file_system" "prometheus" {
  creation_token = "${local.name_prefix}-data"
  encrypted      = true
  
  throughput_mode                 = var.efs_throughput_mode
  provisioned_throughput_in_mibps = var.efs_provisioned_throughput
  
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  
  tags = local.tags
}

resource "aws_efs_mount_target" "prometheus" {
  count           = length(var.subnet_ids)
  file_system_id  = aws_efs_file_system.prometheus.id
  subnet_id       = var.subnet_ids[count.index]
  security_groups = [var.ecs_security_group_id]
}

resource "aws_efs_access_point" "prometheus" {
  file_system_id = aws_efs_file_system.prometheus.id
  
  posix_user {
    gid = 65534 # nobody
    uid = 65534 # nobody
  }
  
  root_directory {
    path = "/prometheus"
    creation_info {
      owner_gid   = 65534
      owner_uid   = 65534
      permissions = "755"
    }
  }
  
  tags = local.tags
}