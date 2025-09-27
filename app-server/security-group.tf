 resource "aws_security_group" "cooking-corner-sg" {
  name = "cooking-corner security group"
  description = "Allow HTTP,HTTPS and SSH traffic via Terraform"

  dynamic "ingress" {
    for_each = [80,22,443,3000,0]
    iterator = "ports"
    content {
      description = "Allow traffic"
      from_port   = ports.value
      to_port     = ports.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    
  }
}