provider "aws" {
  region = var.aws_region # my default region
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}
