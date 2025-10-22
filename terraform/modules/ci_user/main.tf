variable "user_name" {
  description = "IAM user name for GitHub Actions"
  type        = string
  default     = "github-actions-user"
}

variable "policy_name" {
  description = "IAM policy name for GitHub Actions"
  type        = string
  default     = "github-actions-policy"
}

variable "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  type        = string
}

resource "aws_iam_user" "github_actions" {
  name = var.user_name
}

resource "aws_iam_policy" "github_actions_policy" {
  name        = "github-actions-policy"
  description = "Policy for GitHub Actions to access S3 frontend and CloudFront"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3Frontend"
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetObject"
        ]
        Resource = [
          var.s3_bucket_arn,
          "${var.s3_bucket_arn}/*"
        ]
      },
      {
        Sid    = "CloudFrontInvalidation"
        Effect = "Allow"
        Action = [
          "cloudfront:CreateInvalidation",
          "cloudfront:GetInvalidation",
          "cloudfront:ListInvalidations",
          "cloudfront:GetDistribution",
          "cloudfront:ListDistributions"
        ]
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_user_policy_attachment" "github_actions_attach" {
  user       = aws_iam_user.github_actions.name
  policy_arn = aws_iam_policy.github_actions_policy.arn
}

resource "aws_iam_access_key" "github" {
  user = aws_iam_user.github_actions.name
}

output "github_actions_access_key_id" {
  value     = aws_iam_access_key.github.id
  sensitive = true
}

output "github_actions_secret_access_key" {
  value     = aws_iam_access_key.github.secret
  sensitive = true
}

output "github_actions_iam_user" {
  value = aws_iam_user.github_actions.name
}
