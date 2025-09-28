resource "aws_subnet" "load_balancer_subnet1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.lb_subnet_cidr_1
  map_public_ip_on_launch = var.map_public_ip
  availability_zone       = format("%sa", var.region)
  tags = {
    Name = var.subnet_name_tags.lb
  }
}

resource "aws_subnet" "load_balancer_subnet2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.lb_subnet_cidr_2
  map_public_ip_on_launch = var.map_public_ip
  availability_zone       = format("%sb", var.region)
  tags = {
    Name = var.subnet_name_tags.lb
  }
}

resource "aws_subnet" "rds_subnet1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.rds_subnet_cidr_1
  map_public_ip_on_launch = var.map_public_ip
  availability_zone       = format("%sa", var.region)

  tags = {
    Name = var.subnet_name_tags.rds1
  }
}

resource "aws_subnet" "rds_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.rds_subnet_cidr_2
  map_public_ip_on_launch = var.map_public_ip
  availability_zone       = format("%sb", var.region)

  tags = {
    Name = var.subnet_name_tags.rds2
  }
}

resource "aws_subnet" "backend_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.backend_subnet_cidr
  map_public_ip_on_launch = var.map_public_ip

  tags = {
    Name = var.subnet_name_tags.backend
  }
}

resource "aws_subnet" "rds_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.rds_subnet_cidr
  map_public_ip_on_launch = var.map_public_ip

  tags = {
    Name = var.subnet_name_tags.rds
  }
}

resource "aws_subnet" "ecs_cluster_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.ecs_cluster_subnet_cidr
  map_public_ip_on_launch = var.map_public_ip

  tags = {
    Name = var.subnet_name_tags.frontend
  }
}

# RDS Subnet Group (using public subnets)
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = var.rds_subnet_group_name
  subnet_ids = [aws_subnet.rds_subnet1.id, aws_subnet.rds_subnet_2.id]

  tags = {
    Name = var.rds_subnet_group_name
  }
}


