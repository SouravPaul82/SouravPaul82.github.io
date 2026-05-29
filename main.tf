provider "aws" {
  region = "us-east-1" 
}

# 1. Create the S3 Bucket
resource "aws_s3_bucket" "resume_bucket" {
  bucket        = "sourav4798-projects-01" # Must be globally unique
  force_destroy = false                       # Allows terraform destroy to empty files if needed
}

# 2. Configure Bucket for Static Website Hosting
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.resume_bucket.id

  index_document {
    suffix = "index.html"
  }
}

# 3. Block Direct Public Access (Best practice when paired with CloudFront)
resource "aws_s3_bucket_public_access_block" "public_block" {
  bucket                  = aws_s3_bucket.resume_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 4. Output the Bucket Name for your Pipeline
output "s3_bucket_name" {
  value       = aws_s3_bucket.resume_bucket.id
  description = "Copy this value into your GitHub repository secrets"
}