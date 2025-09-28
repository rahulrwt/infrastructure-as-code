
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true  # Enables DNS resolution
  enable_dns_hostnames = true  # Enables DNS hostnames

  tags = {
    Name = "main-vpc"
  }
}
