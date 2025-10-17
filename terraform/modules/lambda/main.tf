variable "project_name" {
  type = string
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "tags" {
  description = "Tags to apply to CloudFront resources"
  type        = map(string)
  default     = {}
}

variable "allowed_origin" {
  type        = string
  description = "Allowed origin for Lambda function CORS"
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.project_name}-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })

  tags = merge({
    Name = "${var.project_name}-role"
  }, var.tags)
}

# --- Attach AWSLambdaBasicExecutionRole (CloudWatch logs) ---
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_access" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_lambda_function" "view_counter" {
  function_name = "${var.project_name}-${var.lambda_function_name}"
  runtime       = "nodejs22.x"
  handler       = "${var.lambda_function_name}.handler"
  role          = aws_iam_role.lambda_exec_role.arn
  filename      = data.archive_file.lambda_zip.output_path

  tags = merge({
    Name = var.lambda_function_name
  }, var.tags)

}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/${var.lambda_function_name}.mjs"
  output_path = "${path.module}/${var.lambda_function_name}.mjs.zip"
}

resource "aws_lambda_function_url" "view_counter_url" {
  function_name      = aws_lambda_function.view_counter.function_name
  authorization_type = "NONE"

  cors {
    allow_origins = [var.allowed_origin]
    allow_methods = ["GET", "POST"]
    allow_headers = ["*"]
  }

  depends_on = [aws_lambda_function.view_counter]
}

output "function_url" {
  value = aws_lambda_function_url.view_counter_url.function_url
}
