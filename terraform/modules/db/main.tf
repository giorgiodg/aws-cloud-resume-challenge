variable "project_name" {
  type = string
}

variable "tags" {
  description = "Tags to apply to CloudFront resources"
  type        = map(string)
  default     = {}
}

resource "aws_dynamodb_table" "counter_table" {
  name         = var.project_name
  hash_key     = "id"
  billing_mode = "PAY_PER_REQUEST" # on-demand, no capacity units needed

  # Attributes
  attribute {
    name = "id"
    type = "S"
  }

  tags = merge({
    Name = "${var.project_name}-db"
  }, var.tags)
}

# --- Insert initial item  ---
resource "aws_dynamodb_table_item" "initial_counter" {
  table_name = aws_dynamodb_table.counter_table.name
  hash_key   = "id"

  item = jsonencode({
    id    = { S = "1" }
    views = { N = "0" }
  })
}

# output "dynamodb_table_name" {
#   description = "The name of the DynamoDB table"
#   value       = aws_dynamodb_table.counter_table.name
# }

# output "dynamodb_table_arn" {
#   description = "The ARN of the DynamoDB table"
#   value       = aws_dynamodb_table.counter_table.arn
# }
