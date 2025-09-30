provider "aws" {
  region = var.aws_region
}

module "frontend_website" {
  source              = "./modules/s3"
  project_name        = var.project_name
  website_output_path = var.website_output_path
  tags                = var.project_tags
}

module "frontend_cdn" {
  source             = "./modules/cloudfront"
  project_name       = var.project_name
  origin_bucket_id   = module.frontend_website.bucket_id
  origin_bucket_arn  = module.frontend_website.bucket_arn
  origin_domain_name = module.frontend_website.bucket_domain_name
  tags               = var.project_tags
}

module "db_table" {
  source       = "./modules/db"
  project_name = var.project_name
  tags         = var.project_tags
}

## outputs
output "cdn_domain_name" {
  description = "Public domain name of the CloudFront distribution"
  value       = module.frontend_cdn.cloudfront_domain_name
}

output "cdn_distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = module.frontend_cdn.cloudfront_distribution_id
}
