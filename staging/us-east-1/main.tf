module "asg" {
    source = "../../modules/asg"
    app_name = var.app_name
    asg_name = "${var.app_name}-server-asg"
    instance-type = var.instance-type
    app-server-ami = var.app-server-ami
    aws-key-pair-name = "staging-ssh"
    aws_region = var.aws_region
    max_bid = var.max_bid
    spot_instance_option = var.spot_instance_option
    target_group_arns = module.load_balancer.target_group_arns
    subnet_ids = module.vpc.lb_subnet_ids
    asg_sg_ids = module.security_group.asg_sg_ids
    iam_instance_profile_name = module.iam.iam_instance_profile_name
    environment_type = var.environment_type
    prefix = "staging"
    s3_access_key = ""
    s3_region = "us-east-1"
    s3_secret_key = ""
}

module "iam" {
  source = "../../modules/iam"
  ec2_role_name = "server-iam-role"
  prefix = "staging"
}

module "load_balancer" {
  source = "../../modules/load-balancer"
  lb_name = "${var.app_name}-lb"
  vpc_id = module.vpc.vpc_id
  asg_id = module.asg.asg_id
  lb_subnet_ids = module.vpc.lb_subnet_ids
  lb_sg_ids = module.security_group.lb_sg_ids
  certificate_arn = var.certificate_arn
  prefix = "staging"
}

module "rds" {
  source = "../../modules/rds"
  rds_sg_ids = module.security_group.rds_sg_ids
  rds_subnet_group_name = module.vpc.rds_subnet_group_name
  rds_instance_class = "db.t4g.micro"
  database_name = "${var.app_name}-rds-instance"
  database_password ="#ThisIsM0stSecureP@ssw0rd"
  database_username = "admin"
  prefix = "staging"
  rds_disk_size = 20
  database_disk_type = "gp2"
  retention_period = 0
  enable_performance_insights = false
}

module "security_group" {
  source = "../../modules/security-group"
  vpc_id = module.vpc.vpc_id
  prefix = "staging"
}

module "vpc" {
  source = "../../modules/vpc"
  region = var.aws_region

}

#Add prefix
module "S3" {
  source = "../../modules/S3"
  prefix = var.prefix
  create_release_bucket = false
}

# module "waf" {
#   source = "../../modules/waf"
  
#   waf_name             = "${var.app_name}-waf"
#   alb_arn              = module.load_balancer.lb_arn
  
#   # # Configure rate limiting (requests per 5 minutes per IP)
#   # rate_limit           = 2000
  
#   # Optional: Block specific IPs if you've identified malicious traffic
#   # blocked_ip_addresses = ["192.0.2.0/24"] # Example IP range
  
#   enable_logging       = true
#   log_retention_days   = 7
  
#   tags = {
#     Environment = "production"
#     ManagedBy   = "terraform"
#   }
# }