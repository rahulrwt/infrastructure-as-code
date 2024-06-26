resource "aws_autoscaling_group" "app-server-asg" {
  name                 = "app-server-asg"
  launch_template {
    id      = aws_launch_template.app-server-template.id
    version = "$Latest"
    # security_groups = ["${aws_security_group.cooking-corner-sg.id}"]
  }
  min_size             = 0
  max_size             = 1
  desired_capacity     = 1
  vpc_zone_identifier  = [local.subnet] 
}