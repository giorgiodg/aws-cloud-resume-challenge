variable "project_name" {
  type        = string
  description = "Prefix for S3 bucket name"
}

variable "website_output_path" {
  type        = string
  description = "Path to frontend dist folder"
}

variable "tags" {
  description = "Tags to apply to CloudFront resources"
  type        = map(string)
  default     = {}
}

# --- S3 bucket (private) ---
resource "aws_s3_bucket" "site" {
  bucket = "${var.project_name}-site"

  tags = merge({
    Name = "${var.project_name}-site"
  }, var.tags)
}

resource "aws_s3_bucket_public_access_block" "site" {
  bucket                  = aws_s3_bucket.site.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# --- Upload dist files ---
locals {
  dist_files = fileset(var.website_output_path, "**")
}

resource "aws_s3_object" "all_dist_files" {
  for_each = { for f in local.dist_files : f => f }

  bucket = aws_s3_bucket.site.id
  key    = each.key
  source = "${var.website_output_path}/${each.value}"

  content_type = lookup({
    html = "text/html"
    css  = "text/css"
    js   = "application/javascript"
  }, split(".", each.value)[length(split(".", each.value)) - 1], "application/octet-stream")
}

# --- Outputs ---
output "bucket_id" {
  value = aws_s3_bucket.site.id
}

output "bucket_arn" {
  value = aws_s3_bucket.site.arn
}

output "bucket_domain_name" {
  value = aws_s3_bucket.site.bucket_regional_domain_name
}
