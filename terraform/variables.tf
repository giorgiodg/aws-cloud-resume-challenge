variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "eu-west-3"
}

variable "project_name" {
  description = "A name prefix for all resources"
  type        = string
  default     = "giorgiodg-cloud-resume-challenge"
}

variable "project_tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Project = "Cloud Resume Challenge"
    Owner   = "giorgio"
  }
}
variable "website_output_path" {
  description = "Path to frontend dist folder"
  type        = string
  default     = "../frontend/dist"
}

variable "lambda_function_name" {
  description = "Name for the view counter lambda function View"
  type        = string
  default     = "view_counter"
}

variable "alternate_domain_name" {
  type    = string
  default = "https://www.giorgiodg.cloud"
}

variable "cert_domain_name" {
  type    = string
  default = "*.giorgiodg.cloud"
}

variable "acm_certificate_arn" {
  default = "arn:aws:acm:us-east-1:123456789012:certificate/abc123..."
}
