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
