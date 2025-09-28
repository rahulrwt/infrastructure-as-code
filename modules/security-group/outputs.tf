output "asg_sg_ids" {
  value = [aws_security_group.app_sg.id]
}

output "lb_sg_ids" {
  value = [aws_security_group.lb_sg.id]
}

output "rds_sg_ids" {
    value = [aws_security_group.rds_sg.id]
}