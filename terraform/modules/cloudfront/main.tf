variable "project_name" {
  type        = string
  description = "Prefix for CloudFront resources"
}

variable "origin_bucket_id" {
  type        = string
  description = "S3 bucket ID"
}

variable "origin_bucket_arn" {
  type        = string
  description = "S3 bucket ARN"
}

variable "origin_domain_name" {
  type        = string
  description = "S3 bucket regional domain name"
}

variable "tags" {
  description = "Tags to apply to CloudFront resources"
  type        = map(string)
  default     = {}
}

# --- CloudFront OAC ---
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = var.project_name
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"

}

# --- CloudFront Distribution ---
resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  default_root_object = "index.html"

  origin {
    domain_name              = var.origin_domain_name
    origin_id                = "${var.project_name}-s3-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.project_name}-s3-origin"

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies { forward = "none" }
    }

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.main.arn
    }
  }

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = merge({
    Name = "${var.project_name}"
  }, var.tags)
}

# --- CloudFront function for SPA routing ---
resource "aws_cloudfront_function" "main" {
  name    = "${var.project_name}-rewrite"
  runtime = "cloudfront-js-2.0"
  publish = true
  code    = <<EOF
    function handler(event) {
      var request = event.request;
      var uri = request.uri;

      if (uri.endsWith('/')) {
        request.uri += 'index.html';
      } else if (!uri.includes('.')) {
        request.uri += '/index.html';
      }

      return request;
    }
  EOF
}

# --- Bucket policy allowing CloudFront ---
data "aws_iam_policy_document" "cf_access" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${var.origin_bucket_arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.cdn.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "cf_policy" {
  bucket = var.origin_bucket_id
  policy = data.aws_iam_policy_document.cf_access.json
}

# --- Output ---
output "cloudfront_domain_name" {
  description = "The CloudFront distribution domain (use in DNS CNAME)"
  value       = aws_cloudfront_distribution.cdn.domain_name
}

output "cloudfront_distribution_id" {
  description = "The CloudFront distribution ID (useful for invalidations)"
  value       = aws_cloudfront_distribution.cdn.id
}
