locals {
  # Automatically calculate subnet CIDRs from the VPC CIDR
  # Assumes /24 subnets within the VPC CIDR
  
  vpc_cidr_parts = split("/", var.vpc_cidr)
  vpc_base = split(".", local.vpc_cidr_parts[0])
  vpc_prefix = "${local.vpc_base[0]}.${local.vpc_base[1]}"
  
  # Calculate subnet CIDRs - using cidrsubnet function for automatic calculation
  lb_subnet_cidr_1      = cidrsubnet(var.vpc_cidr, 8, 1)   # x.x.1.0/24
  backend_subnet_cidr   = cidrsubnet(var.vpc_cidr, 8, 2)   # x.x.2.0/24
  rds_subnet_cidr       = cidrsubnet(var.vpc_cidr, 8, 3)   # x.x.3.0/24
  ecs_cluster_subnet_cidr = cidrsubnet(var.vpc_cidr, 8, 4) # x.x.4.0/24
  lb_subnet_cidr_2      = cidrsubnet(var.vpc_cidr, 8, 5)   # x.x.5.0/24
  rds_subnet_cidr_1     = cidrsubnet(var.vpc_cidr, 8, 6)   # x.x.6.0/24
  rds_subnet_cidr_2     = cidrsubnet(var.vpc_cidr, 8, 7)   # x.x.7.0/24
}