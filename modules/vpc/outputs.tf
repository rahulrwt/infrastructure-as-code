output "rds_subnet_group_name" {
  value = aws_db_subnet_group.rds_subnet_group.name
}

output "asg_subnet_ids" {
  value = aws_subnet.backend_subnet.id
}

output "lb_subnet_ids" {
  value = [aws_subnet.load_balancer_subnet1.id, aws_subnet.load_balancer_subnet2.id]
  
}
output "ecs_cluster_subnet_ids" {
  value = [aws_subnet.ecs_cluster_subnet.id]
  
}
output "vpc_id" {
  value = aws_vpc.main.id
  
}