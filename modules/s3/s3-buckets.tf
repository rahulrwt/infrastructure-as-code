variable "prefix" {
  description = "Prefix to be used for resource naming to uniquely identify the environment (e.g., staging, production)"
  type        = string
  default = ""
}

variable "create_release_bucket" {
  description = "Flag to create the release artifact bucket"
  type        = bool
  
}

variable "create_dashboard_bucket" {
  description = "Flag to create the deployment dashboard bucket"
  type        = bool
  default     = false
}

variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = ""
}


locals {
  name_prefix = var.prefix != "" ? "${var.prefix}-" : ""
}

# Create S3 Bucket
resource "aws_s3_bucket" "app-release-artifact" {            #should be created in 1 environment only and should be shared
  count = var.create_release_bucket ? 1 : 0
  bucket = "${var.app_name}-release-artifact"
}

resource "aws_s3_bucket" "app-objects" {
  bucket = "${local.name_prefix}${var.app_name}-objects"
}

resource "aws_s3_bucket" "proappppo-secrets" {
  bucket = "${local.name_prefix}${var.app_name}-secrets"
}

resource "aws_s3_bucket" "app-public-objects" {
  bucket = "${local.name_prefix}${var.app_name}-public-objects"
}

resource "aws_s3_bucket" "app-customer-objects" {
  bucket = "${local.name_prefix}${var.app_name}-customer-objects"
}

resource "aws_s3_bucket" "app-terraform-state-bucket" {
  bucket = "${local.name_prefix}${var.app_name}-terraform-state-bucket"
}

# Deployment Dashboard Bucket
resource "aws_s3_bucket" "app-deployment-dashboard" {
  count  = var.create_dashboard_bucket ? 1 : 0
  bucket = "${local.name_prefix}${var.app_name}-deployment-dashboard"
}

#enable versioning
resource "aws_s3_bucket_versioning" "app_release_artifact_versioning" {
  bucket = aws_s3_bucket.app-terraform-state-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Ensure the bucket is private by blocking all public access
resource "aws_s3_bucket_public_access_block" "private_access" {
  count = var.create_release_bucket ? 1 : 0
  bucket = aws_s3_bucket.app-release-artifact[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "app_object_private_access" {
  bucket = aws_s3_bucket.app-objects.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "app_secret_object_private_access" {
  bucket = aws_s3_bucket.app-secrets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Configure public access for app-public-objects bucket
resource "aws_s3_bucket_ownership_controls" "public_objects_ownership" {
  bucket = aws_s3_bucket.app-public-objects.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "public_objects_access" {
  bucket = aws_s3_bucket.app-public-objects.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "public_objects_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.public_objects_ownership,
    aws_s3_bucket_public_access_block.public_objects_access,
  ]

  bucket = aws_s3_bucket.app-public-objects.id
  acl    = "public-read"
}

# Bucket policy to allow public read access to all objects
resource "aws_s3_bucket_policy" "public_objects_policy" {
  depends_on = [aws_s3_bucket_public_access_block.public_objects_access]
  
  bucket = aws_s3_bucket.app-public-objects.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.app-public-objects.arn}/*"
      },
    ]
  })
}

resource "aws_s3_bucket_public_access_block" "customer_objects_access" {
  bucket = aws_s3_bucket.app-customer-objects.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
# Dashboard bucket public access configuration
resource "aws_s3_bucket_ownership_controls" "dashboard_ownership" {
  count  = var.create_dashboard_bucket ? 1 : 0
  bucket = aws_s3_bucket.app-deployment-dashboard[0].id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "dashboard_access" {
  count  = var.create_dashboard_bucket ? 1 : 0
  bucket = aws_s3_bucket.app-deployment-dashboard[0].id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "dashboard_acl" {
  count = var.create_dashboard_bucket ? 1 : 0
  depends_on = [
    aws_s3_bucket_ownership_controls.dashboard_ownership,
    aws_s3_bucket_public_access_block.dashboard_access,
  ]

  bucket = aws_s3_bucket.app-deployment-dashboard[0].id
  acl    = "public-read"
}

# Website configuration for dashboard bucket
resource "aws_s3_bucket_website_configuration" "dashboard_website" {
  count  = var.create_dashboard_bucket ? 1 : 0
  bucket = aws_s3_bucket.app-deployment-dashboard[0].id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# CORS configuration for dashboard bucket
resource "aws_s3_bucket_cors_configuration" "dashboard_cors" {
  count  = var.create_dashboard_bucket ? 1 : 0
  bucket = aws_s3_bucket.app-deployment-dashboard[0].id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

# Bucket policy for dashboard public access
resource "aws_s3_bucket_policy" "dashboard_policy" {
  count      = var.create_dashboard_bucket ? 1 : 0
  depends_on = [aws_s3_bucket_public_access_block.dashboard_access]
  
  bucket = aws_s3_bucket.app-deployment-dashboard[0].id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.app-deployment-dashboard[0].arn}/*"
      },
    ]
  })
}

# Get AWS Account ID dynamically
data "aws_caller_identity" "current" {}

