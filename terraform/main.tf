module "frontend_website" {
  source              = "./modules/s3"
  project_name        = var.project_name
  website_output_path = var.website_output_path
  tags                = var.project_tags
}

# Cert Lookup in ACM us-east-1
data "aws_acm_certificate" "cf_cert" {
  domain      = var.cert_domain_name
  statuses    = ["ISSUED"]
  most_recent = true
  provider    = aws.us_east_1
}

module "frontend_cdn" {
  source              = "./modules/cloudfront"
  project_name        = var.project_name
  origin_bucket_id    = module.frontend_website.bucket_id
  origin_bucket_arn   = module.frontend_website.bucket_arn
  origin_domain_name  = module.frontend_website.bucket_domain_name
  cert_domain_name    = var.cert_domain_name
  acm_certificate_arn = data.aws_acm_certificate.cf_cert.arn
  tags                = var.project_tags
}

module "db" {
  source       = "./modules/db"
  project_name = var.project_name
  tags         = var.project_tags
}

module "lambda" {
  source               = "./modules/lambda"
  lambda_source_file   = var.lambda_source_file
  project_name         = var.project_name
  lambda_function_name = var.lambda_function_name
  tags                 = var.project_tags
  allowed_origin       = var.alternate_domain_name
}

module "ci_user" {
  source        = "./modules/ci_user"
  user_name     = "github-actions-user"
  policy_name   = "github-actions-policy"
  s3_bucket_arn = module.frontend_website.bucket_arn
}


## outputs
output "cloudfront_domain_name" {
  description = "Public domain name of the CloudFront distribution"
  value       = module.frontend_cdn.cloudfront_domain_name
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = module.frontend_cdn.cloudfront_distribution_id
}

output "lambda_url" {
  description = "URL of the Lambda function"
  value       = module.lambda.lambda_url
}

output "acm_certificate_arn" {
  description = "ACM certificate ARN used for CloudFront"
  value       = data.aws_acm_certificate.cf_cert.arn
}

output "github_actions_access_key_id" {
  description = "Access key ID for the GitHub Actions IAM user"
  value       = module.ci_user.github_actions_access_key_id
  sensitive   = true
}

output "github_actions_secret_access_key" {
  description = "Secret access key for the GitHub Actions IAM user"
  value       = module.ci_user.github_actions_secret_access_key
  sensitive   = true
}
