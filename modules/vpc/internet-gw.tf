
# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Create a Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  # Route for public internet access via IGW
  route {
    cidr_block = "0.0.0.0/0"   # Allows all outbound traffic
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Associate Route Table with a Public Subnet
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.load_balancer_subnet1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_assoc2" {
  subnet_id      = aws_subnet.load_balancer_subnet2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "backend_assoc" {
  subnet_id      = aws_subnet.backend_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "database_assoc" {
  subnet_id      = aws_subnet.rds_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "database_assoc1" {
  subnet_id      = aws_subnet.rds_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "database_assoc2" {
  subnet_id      = aws_subnet.rds_subnet1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "ecs_cluster_assoc" {
  subnet_id      = aws_subnet.ecs_cluster_subnet.id
  route_table_id = aws_route_table.public_rt.id
  
}